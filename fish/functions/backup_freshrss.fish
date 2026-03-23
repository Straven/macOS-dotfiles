function backup_freshrss --description 'Backup FreshRSS to OneDrive'
    # OneDrive backup location
    set backup_dir ~/OneDrive/StravenConfigs/straven-ys-tools/containers/freshrss/backups
    set backup_timestamp (date +%Y%m%d-%H%M%S)

    # Ensure backup directoy exists
    if not test -d $backup_dir
        echo "📁 Creating backup directory: $backup_dir"
        mkdir -p $backup_dir

        # Verify creation succeeded
        if not test -d $$backup_dir
            echo "❌ Failed to create backup directory: $backup_dir"
            return 1
        end
    end

    # Ensure directory is writable
    if not test -w $backup_dir
        echo "🔧 Fixing permissions on backup directory..."
        chmod u+w $backup_dir

        # Verify fix succeeded
        if not test -w $backup_dir
            echo "❌ Failed to make backup directory writable: $backup_dir"
            return 1
        end
    end

    # Check if FreshRSS pod is running
    if not podman pod ps --filter "name=^freshrss\$" --format "{{.Status}}" | grep -q Running
        echo "❌ FreshRSS pod is not running!"
        echo "💡 Starting it with: podman pod start freshrss"
        podman pod start freshrss

        # Verify if it's started
        if not podman pod ps --filter "name=^freshrss\$" --format "{{.Status}}" | grep -q Running
            echo "❌ Unable to run FreshRSS pod! 📄 Please check the logs!"
            return 1
        end
    end

    # Container name inside the pod
    set container_name freshrss-freshrss

    # Create backup file paths
    set data_backup "$backup_dir/freshrss-data-$backup_timestamp.tar.gz"
    set extensions_backup "$backup_dir/freshrss-extensions-$backup_timestamp.tar.gz"
    set pod_yaml_backup "$backup_dir/freshrss-pod-$backup_timestamp.yaml"

    echo "🗄️  Backing up FreshRSS to OneDrive/StravenConfigs..."

    # Backup the data volume
    echo "📦 Backing up data volume..."
    podman exec $container_name \
        tar czf - /var/www/FreshRSS/data >$data_backup

    if test $status -ne 0
        echo "❌ Data backup failed!"
        return 1
    end
    echo "✅ Data backup saved: freshrss-data-$backup_timestamp.tar.gz"

    # Backup the extensions volume
    echo "📦 Backing up extensions volume..."
    podman exec $container_name \
        tar czf - /var/www/FreshRSS/extensions >$extensions_backup

    if test $status -ne 0
        echo "❌ Extensions backup failed!"
        return 1
    end
    echo "✅ Extensions backup saved: freshrss-extensions-$backup_timestamp.tar.gz"

    # Also save current pod YAML with timestamp
    if test -f ~/straven-ys-tools/containers/freshrss/freshrss-pod.yaml
        cp ~/straven-ys-tools/containers/freshrss/freshrss-pod.yaml \
            $pod_yaml_backup
        echo "📄 Pod YAML backed up"
    end

    echo "☁️  OneDrive will sync automatically..."

    # Keep only last 14 backups (2 weeks retention)
    ls -t $backup_dir/freshrss-data-*.tar.gz | tail -n +15 | xargs rm -f 2>/dev/null
    ls -t $backup_dir/freshrss-extensions-*.tar.gz | tail -n +15 | xargs rm -f 2>/dev/null
    ls -t $backup_dir/freshrss-pod-*.yaml | tail -n +15 | xargs rm -f 2>/dev/null

    echo "🧹 Old backups cleaned (keeping 14 most recent)"
    echo "✨ Backup complete!"
end

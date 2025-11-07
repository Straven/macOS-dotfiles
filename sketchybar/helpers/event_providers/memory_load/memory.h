#include <mach/mach.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/sysctl.h>

struct memory {
  mach_port_t host;
  vm_size_t page_size;
  uint64_t total_memory;
  double free_memory;
  double used_memory;
  double used_percentage;
};

static inline void memory_init(struct memory *memory) {
  memory->host = mach_host_self();
  host_page_size(memory->host, &memory->page_size);
}

static inline void memory_update(struct memory *memory) {
  // Get the physical memory size
  int mib[2] = {CTL_HW, HW_MEMSIZE};
  uint64_t physical_memory;
  size_t length = sizeof(physical_memory);
  if (sysctl(mib, 2, &physical_memory, &length, NULL, 0) != 0) {
    printf("Error: Could not read total physical memory.\n");
    return;
  }

  // Get VM statistics using the Mach API (same as Activity Monitor)
  vm_statistics64_data_t vm_stat;
  mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
  
  if (host_statistics64(memory->host, HOST_VM_INFO64, 
                        (host_info64_t)&vm_stat, &count) != KERN_SUCCESS) {
    printf("Error: Failed to get VM statistics.\n");
    return;
  }

  // Conversion factor
  double bytes_to_gb = 1024.0 * 1024.0 * 1024.0;
  double page_size_bytes = (double)memory->page_size;

  // Calculate memory using Activity Monitor formula:
  // App Memory = Internal + Purgeable
  // Memory Used = App Memory + Wired + Compressed
  double app_memory = (vm_stat.internal_page_count + vm_stat.purgeable_count) * 
                      page_size_bytes / bytes_to_gb;
  double wired_memory = vm_stat.wire_count * page_size_bytes / bytes_to_gb;
  double compressed_memory = vm_stat.compressor_page_count * page_size_bytes / bytes_to_gb;
  
  memory->free_memory = vm_stat.free_count * page_size_bytes / bytes_to_gb;
  memory->used_memory = app_memory + wired_memory + compressed_memory;
  memory->total_memory = (double)physical_memory / bytes_to_gb;
  memory->used_percentage = (memory->used_memory / memory->total_memory) * 100.0;
}

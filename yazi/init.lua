require("full-border"):setup {
    type = ui.Border.ROUNDED,
}
require("copy-file-contents"):setup {
    append_char = "\n",
    notification = true,
}
require("starship"):setup({
    hide_flags = false,
    flags_after_prompt = true,
    show_right_prompt = false,
    hide_count = false,
    count_separator = " ",
})

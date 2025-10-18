require("sessions").setup({
    events = { "BufEnter" },
    session_filepath = ".nvim/session",
    absolute = false,
})

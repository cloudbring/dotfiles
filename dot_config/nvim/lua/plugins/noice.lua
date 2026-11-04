return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}
    -- Neovim bug #36928: semantic token range requests generate orphaned IDs that
    -- copilot's cancel_inflight_requests hits after the request already completed.
    -- Fixed in nvim nightly (PR #36950), not yet in stable. Cover both the
    -- msg_show/rpc_error UI path and the vim.notify path in case Snacks routes first.
    table.insert(opts.routes, 1, {
      filter = {
        any = {
          { event = "msg_show", kind = "rpc_error", find = "Cannot find request" },
          { event = "notify", find = "Cannot find request" },
        },
      },
      opts = { skip = true },
    })
    -- Node.js informational stderr that nvim's RPC transport surfaces as errors
    table.insert(opts.routes, 2, {
      filter = {
        any = {
          { find = "ExperimentalWarning" },
          { find = "DeprecationWarning" },
        },
      },
      opts = { skip = true },
    })
    -- marksman writes INF-level startup logs to stderr; nvim treats all stderr as errors
    table.insert(opts.routes, 3, {
      filter = { event = "msg_show", kind = "rpc_error", find = "marksman" },
      opts = { skip = true },
    })
  end,
}

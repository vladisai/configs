-- Code tours: .tours/*.tour.json in a repo, walked stop by stop.
-- :CodeTourList or ,ct to pick one; <Tab>/<S-Tab> next/previous stop, K full note, q quit.
return {
  {
    "krshrimali/codetours.nvim",
    commit = "48e68b7c88a7bcb374744868a478e77701c12a1b",
    cmd = {
      "CodeTourList", "CodeTourStart", "CodeTourNext", "CodeTourPrev", "CodeTourQuit", "CodeTourShowNote",
      "CodeTourRecord", "CodeTourAddStop", "CodeTourFinish", "CodeTourCancel",
    },
    keys = {
      { "<leader>ct", "<cmd>CodeTourList<cr>", desc = "Code Tour: list/start" },
    },
    opts = {
      ui = { max_width = 76, max_height = 20 },
    },
  },
}

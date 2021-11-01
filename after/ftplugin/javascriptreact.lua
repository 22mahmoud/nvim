vim.cmd [[runtime! after/ftplugin/javascript.lua]]

G.imap('<c-q><c-e>', '<c-v><c-a><c-]>', { bufnr = 0 })

G.abbrev(
  'i',
  'rfc<c-a>',
  [[import React from 'react';]]
    .. [[<cr><cr>]]
    .. [[function NAME() {]]
    .. [[<cr>]]
    .. [[<c-i>]]
    .. [[return 'hello, world';]]
    .. [[<cr>]]
    .. [[}]]
    .. [[<cr>]]
    .. [[export default ;]]
    .. [[<esc>?NAME<esc>cw]]
)

G.abbrev('i', 'us<c-a>', 'const [, ] = useState();<esc>F[a')

G.abbrev('i', 'ue<c-a>', 'useEffect(() => {}, []);<esc>F{a<cr><esc>O<c-i>')

G.abbrev('i', 'ur<c-a>', [[const \ = useRef();<esc>F\s]])

G.imap('<c-q><c-e>', '<c-v><c-a><c-]>', { buffer = 0 })

G.abbrev('i', 'cl<c-a>', [[console.log();<esc>F(a]])
G.abbrev('i', 'clo<c-a>', [[console.log({ \ });<esc>F\s]])
G.abbrev('i', 'cls<c-a>', [[console.log('');<esc>F'i]])

G.abbrev('i', 'fn<c-a>', 'function () {}<esc>F(i')

G.abbrev('i', 'afn<c-a>', [[const NAME = () => {}<esc>?NAME<esc>cw]])

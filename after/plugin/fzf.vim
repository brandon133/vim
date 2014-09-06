" eclim defines :Buffers first
command! -bar -bang -nargs=? -complete=buffer Buffers  call fzf#vim#buffers(<q-args>, <bang>0)

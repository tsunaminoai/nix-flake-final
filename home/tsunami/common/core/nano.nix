{
  home,
  ...
}: {
  home.file.".nanorc".text = ''

    set tabsize 2
    set tabstospaces
    set historylog
    set quickblank
    set wordbounds
    set zap
    set softwrap
    set atblanks
    set autoindent
    set linenumbers
    set stateflags
    set indicator
    set minibar
    set nohelp
    # set mouse
    set constantshow

    set titlecolor black,cyan
    set keycolor white
    set functioncolor blue
    set numbercolor cyan
  '';
}

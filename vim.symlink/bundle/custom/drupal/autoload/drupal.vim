" @file autoload/drupal.vim

function! drupal#BufEnter()
  if strlen(b:DrupalInfo.CORE)
    let l:drupal_ft='drupal' . b:DrupalInfo['CORE']
    echo l:drupal_ft
    call UltiSnips#AddFiletypes(l:drupal_ft)
  endif
endfun

function! drupal#DrupalInfo()
  " Expect something like /var/www/drupal-7.9/sites/all/modules/ctools
  let l:path = expand('%:p')
  let l:directory = fnamemodify(l:path, ':h')
  let l:info = {
      \  'DRUPAL_ROOT': drupaldetect#DrupalRoot(l:directory),
      \  'INFO_FILE': drupaldetect#InfoPath(l:directory),
      \  'OPEN_COMMAND': drupal#OpenCommand(),
      \}
  let l:info.TYPE = drupal#IniType(l:info.INFO_FILE)
  let l:info.CORE = drupaldetect#CoreVersion(l:info.INFO_FILE)

  if strlen(l:info.CORE) && strlen(l:info.DRUPAL_ROOT)
    let l:info_file = info.DRUPAL_ROOT . '/modules/system/system.info'
    if filereadable(l:info_file)
      let l:info.CORE = drupaldetect#CoreVersion(l:info_file)
    else
      let l:info_file = l:info.DRUPAL_ROOT . '/core/modules/system/system.info'
      if filereadable(l:info_file)
        let l:info.CORE = drupaldetect#CoreVersion(l:info_file)
      endif
    endif
  endif
  return l:info
endfun

" @see http://www.dwheeler.com/essays/open-files-urls.html
function! drupal#OpenCommand() " {{{
if has('win32unix') && executable('cygstart')
  return 'cygstart'
elseif has('unix') && executable('xdg-open')
  return 'xdg-open'
elseif (has('win32') || has('win64')) && executable('cmd')
  return 'cmd /c start'
elseif (has('macunix') || has('unix') && system('uname') =~ 'Darwin')
      \ && executable('open')
  return 'open'
else
  return ''
endif
endfun

"
" @todo:  How do we recognize a Profiler .info file?
function! drupal#IniType(info_path) " {{{
  " Determine make files by their extensions. Parse .yml files.
  let ext = fnamemodify(a:info_path, ':e')

  if ext == 'make' || ext == 'build'
    return 'make'
  elseif ext == 'yml'
    let type = drupaldetect#ParseInfo(a:info_path, 'type', 'yml')
    if strlen(type)
      return type
    endif
  endif

  " If we are not done yet, then parse the path.
  " Borrowed from autoload/pathogen.vim:
  let slash = !exists("+shellslash") || &shellslash ? '/' : '\'
  " If the extension is not 'info' at this point, I do not know how we got
  " here.
  let m_index = strridx(a:info_path, slash . 'modules' . slash)
  let t_index = strridx(a:info_path, slash . 'themes' . slash)
  " If neither matches, try a case-insensitive search.
  if m_index == -1 && t_index == -1
    let m_index = matchend(a:info_path, '\c.*\' . slash . 'modules\' . slash)
    let t_index = matchend(a:info_path, '\c.*\' . slash . 'themes\' . slash)
  endif
  if m_index > t_index
    return 'module'
  elseif m_index < t_index
    return 'theme'
  endif
  " We are not inside a themes/ directory, nor a modules/ directory.  Do not
  " guess.
  return ''
endfun

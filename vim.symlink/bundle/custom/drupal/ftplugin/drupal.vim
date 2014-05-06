augroup Drupal
  let b:DrupalInfo=drupal#DrupalInfo()
  autocmd! BufEnter <buffer> call drupal#BufEnter()
augroup END

#!/usr/bin/python
# coding=UTF-8
# These glyphs, and the mapping of file extensions to glyphs
# has been copied from the vimscript code that is present in
# https://github.com/ryanoasis/vim-devicons
import re;
import os;

# all those glyphs will show as weird squares if you don't have the correct patched font
# My advice is to use NerdFonts which can be found here:
# https://github.com/ryanoasis/nerd-fonts
file_node_extensions = {
    '7z'       : '',
    'ai'       : '',
    'apk'      : '',
    'avi'      : '',
    'bat'      : '',
    'bmp'      : '',
    'bz2'      : '',
    'c'        : '',
    'c++'      : '',
    'cab'      : '',
    'cbr'      : '',
    'cbz'      : '',
    'cc'       : '',
    'clj'      : '',
    'cljc'     : '',
    'cljs'     : '',
    'coffee'   : '',
    'conf'     : '',
    'cp'       : '',
    'cpio'     : '',
    'cpp'      : '',
    'css'      : '',
    'cxx'      : '',
    'd'        : '',
    'dart'     : '',
    'db'       : '',
    'deb'      : '',
    'diff'     : '',
    'dump'     : '',
    'edn'      : '',
    'ejs'      : '',
    'epub'     : '',
    'erl'      : '',
    'exe'      : '',
    'f#'       : '',
    'fish'     : '',
    'flac'     : '',
    'flv'      : '',
    'fs'       : '',
    'fsi'      : '',
    'fsscript' : '',
    'fsx'      : '',
    'gem'      : '',
    'gif'      : '',
    'go'       : '',
    'gz'       : '',
    'gzip'     : '',
    'hbs'      : '',
    'hrl'      : '',
    'hs'       : '',
    'htm'      : '',
    'html'     : '',
    'ico'      : '',
    'ini'      : '',
    'java'     : '',
    'jl'       : '',
    'jpeg'     : '',
    'jpg'      : '',
    'js'       : '',
    'json'     : '',
    'jsx'      : '',
    'less'     : '',
    'lha'      : '',
    'lhs'      : '',
    'log'      : '',
    'lua'      : '',
    'lzh'      : '',
    'lzma'     : '',
    'markdown' : '',
    'md'       : '',
    'mkv'      : '',
    'ml'       : 'λ',
    'mli'      : 'λ',
    'mov'      : '',
    'mp3'      : '',
    'mp4'      : '',
    'mpeg'     : '',
    'mpg'      : '',
    'mustache' : '',
    'ogg'      : '',
    'pdf'      : '',
    'php'      : '',
    'pl'       : '',
    'pm'       : '',
    'png'      : '',
    'psb'      : '',
    'psd'      : '',
    'py'       : '',
    'pyc'      : '',
    'pyd'      : '',
    'pyo'      : '',
    'rar'      : '',
    'rb'       : '',
    'rc'       : '',
    'rlib'     : '',
    'rpm'      : '',
    'rs'       : '',
    'rss'      : '',
    'scala'    : '',
    'scss'     : '',
    'sh'       : '',
    'slim'     : '',
    'sln'      : '',
    'sql'      : '',
    'styl'     : '',
    'suo'      : '',
    't'        : '',
    'tar'      : '',
    'tgz'      : '',
    'ts'       : '',
    'twig'     : '',
    'vim'      : '',
    'vimrc'    : '',
    'wav'      : '',
    'webm'     : '',
    'xml'      : '',
    'xul'      : '',
    'xz'       : '',
    'yml'      : '',
    'zip'      : '',
}

dir_node_exact_matches = {
  
# English
    '.git'                             : '',
    'Desktop'                          : '',
    'Documents'                        : '',
    'Downloads'                        : '',
    'Dropbox'                          : '',
    'Music'                            : '',
    'Pictures'                         : '',
    'Public'                           : '',
    'Templates'                        : '',
    'Videos'                           : '',
    'Uni'                              : '\uf19c',
    'GoogleDrive'                      : '\ue246',
    'OneDrive'                         : '\ue762',
    'code_sys'                         : '\uf668',
    'code_ext'                         : '\uf668',
    'core.d'                           : '\ue5fc',
    'Books'                            : '\uf5bb',
    'code'                             : '\uf668',
    'code_home'                        : '\uf668',
    'core.d'                           : '\ue5fc',
    'Workspace'                        : '',
    'personal'                         : '',
    'system'                           : '',
    'source'                           : 'שׂ',
    'dotfiles'                         : '',
    'code_manager'                     : '',
    'envs'                             : '',
    'Media'                            : '',
  
# Spanish
    'Escritorio'                       : '',
    'Documentos'                       : '',
    'Descargas'                        : '',
    'Música'                           : '',
    'Imágenes'                         : '',
    'Público'                          : '',
    'Plantillas'                       : '',
    'Vídeos'                           : '',
# French
    'Bureau'                           : '',
    'Documents'                        : '',
    'Images'                           : '',
    'Musique'                          : '',
    'Publique'                         : '',
    'Téléchargements'                  : '',
    'Vidéos'                           : '',
# Portuguese
    'Documentos'                       : '',
    'Imagens'                          : '',
    'Modelos'                          : '',
    'Música'                           : '',
    'Público'                          : '',
    'Vídeos'                           : '',
    'Área de trabalho'                 : '',
# Italian
    'Documenti'                        : '',
    'Immagini'                         : '',
    'Modelli'                          : '',
    'Musica'                           : '',
    'Pubblici'                         : '',
    'Scaricati'                        : '',
    'Scrivania'                        : '',
    'Video'                            : '',
# German
    'Bilder'                           : '',
    'Dokumente'                        : '',
    'Musik'                            : '',
    'Schreibtisch'                     : '',
    'Vorlagen'                         : '',
    'Öffentlich'                       : '',
}

file_node_exact_matches = {
  
    '.bash_logout'                     : '',
    '.inputrc'                         : '',
    '.xinitrc'                         : '',
    '.Xdefaults'                       : '',
    '.Xresources'                      : '',
    '.bashprofile'                     : '',
    '.bashrc'                          : '',
    '.dmrc'                            : '',
    '.ds_store'                        : '',
    '.fasd'                            : '',
    '.gitconfig'                       : '',
    '.gitignore'                       : '',
    '.jack-settings'                   : '',
    '.mime.types'                      : '',
    '.nvidia-settings-rc'              : '',
    '.pam_environment'                 : '',
    '.profile'                         : '',
    '.recently-used'                   : '',
    '.selected_editor'                 : '',
    '.vimrc'                           : '',
    '.xinputrc'                        : '',
    'config'                           : '',
    'dropbox'                          : '',
    'exact-match-case-sensitive-1.txt' : 'X1',
    'exact-match-case-sensitive-2'     : 'X2',
    'favicon.ico'                      : '',
    'gruntfile.coffee'                 : '',
    'gruntfile.js'                     : '',
    'gruntfile.ls'                     : '',
    'gulpfile.coffee'                  : '',
    'gulpfile.js'                      : '',
    'gulpfile.ls'                      : '',
    'ini'                              : '',
    'ledger'                           : '',
    'license'                          : '',
    'mimeapps.list'                    : '',
    'node_modules'                     : '',
    'procfile'                         : '',
    'react.jsx'                        : '',
    'user-dirs.dirs'                   : '',
}

def devicon(file):
  if file.is_directory: return dir_node_exact_matches.get(file.relative_path, '')
  return file_node_exact_matches.get(file.relative_path, file_node_extensions.get(file.extension, ''))

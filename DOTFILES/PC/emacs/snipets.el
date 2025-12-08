

(require 'aas)

(add-hook 'emacs-lisp-mode-hook #'aas-activate-for-major-mode)
(add-hook 'sh-mode-hook #'aas-activate-for-major-mode)
(add-hook 'rust-mode-hook #'aas-activate-for-major-mode)



(aas-set-snippets 'sh-mode
  "/case" "case _ in\n\t_)\n\t\t_\n\t\t;;\nesac"
  "/for" "for item in [LIST]\ndo\n\t[COMMANDS]\ndone"
  "/if" "if [ condition ]; then\n\tbody\nfi"
  )

(aas-set-snippets 'emacs-lisp-mode
  ";sep" ";;_________________________________________________"
  )

(aas-set-snippets 'rust-mode
  "rfn" "fn name(arg: _) -> _" "{" "" "}"
  "rasync" "async fn [name]([args]) -> [return]{\n[body]\n}\n"
  )

;;;; pastebin.lisp

(in-package #:pastebin)

(defparameter *valid-payload-types*
  (list
   "4cs" "6502acme" "6502kickass" "6502tasm"  "abap" "actionscript"
   "actionscript3" "ada" "aimms" "algol68" "apache" "applescript"
   "sources" "arduino" "arm" "asm" "asp" "asymptote" "autoconf"
   "autohotkey" "autoit" "avisynth" "awk" "bascomavr" "bash"
   "basic4gl" "dos" "bibtex" "b3d" "blitzbasic" "bmx" "bnf" "boo"
   "bf" "c" "csharp" "winapi" "cpp" "winapi" "qt" "loadrunner"
   "caddcl" "cadlisp" "ceylon" "cfdg" "mac" "chaiscript" "chapel"
   "cil" "clojure" "klonec" "klonecpp" "cmake" "cobol"
   "coffeescript" "cfm" "css" "cuesheet" "d" "dart" "dcl" "dcpu16"
   "dcs" "delphi" "oxygene" "diff" "div" "dot" "e" "ezt" "ecmascript"
   "eiffel" "email" "epc" "erlang" "euphoria" "fsharp" "falcon"
   "filemaker" "fo" "f1" "fortran" "freebasic" "freeswitch" "gambas"
   "gml" "gdb" "gdscript" "genero" "genie" "gettext" "go" "glsl"
   "groovy" "gwbasic" "haskell" "haxe" "hicest" "hq9plus" "html4strict"
   "html5" "icon" "idl" "ini" "inno" "intercal" "io" "ispfpanel" "j"
   "java" "java5" "javascript" "jcl" "jquery" "json" "julia" "kixtart"
   "kotlin" "ksp" "latex" "ldif" "lb" "lsl2" "lisp" "llvm" "locobasic"
   "logtalk" "lolcode" "lotusformulas" "lotusscript" "lscript" "lua"
   "m68k" "magiksf" "make" "mapbasic" "markdown" "matlab" "mercury"
   "metapost" "mirc" "mmix" "61" "modula2" "modula3" "68000devpac"
   "mpasm" "mxml" "mysql" "nagios" "netrexx" "newlisp" "nginx" "nim"
   "nsis" "oberon2" "objeck" "objc" "ocaml" "brief" "octave" "pf" "glsl"
   "oorexx" "oobas" "oracle8" "oracle11" "oz" "parasail" "parigp"
   "pascal" "pawn" "pcre" "per" "perl" "perl6" "phix" "php" "brief"
   "pic16" "pike" "pixelbender" "pli" "plsql" "postgresql" "postscript"
   "povray" "powerbuilder" "powershell" "proftpd" "progress" "prolog"
   "properties" "providex" "puppet" "purebasic" "pycon" "python" "pys60"
   "q" "qbasic" "qml" "rsplus" "racket" "rails" "rbs" "rebol" "reg"
   "rexx" "robots" "roff" "rpmspec" "ruby" "gnuplot" "rust" "sas"
   "scala" "scheme" "scilab" "scl" "sdlbasic" "smalltalk" "smarty"
   "spark" "sparql" "sqf" "sql" "sshconfig" "standardml" "stonescript"
   "sclang" "swift" "systemverilog" "tsql" "tcl" "teraterm" "texgraph"
   "thinbasic" "typescript" "typoscript" "unicon" "uscript" "upc" "urbi"
   "vala" "vbnet" "vbscript" "vedit" "verilog" "vhdl" "vim" "vb"
   "visualfoxpro" "visualprolog" "whitespace" "whois" "winbatch" "xbasic"
   "xml" "xojo" "conf" "xpp" "yaml" "yara" "z80" "zxbasic"))

(defparameter *valid-expire-times*
  (list "N" "10M" "1H" "1D" "1W" "2W" "1M" "6M" "1Y"))

(defun api-post (uri options)
  (multiple-value-list
   (drakma:http-request uri
			:method :post
			:content
			(jeff:join
			 (mapcar
			  (lambda (n)
			    (jeff:join (list (car n) (cdr n)) #\=))
			  options)
			 #\&))))

(defun get-user-key (api-dev-key api-user-name api-user-password)
  (let ((result
	  (api-post
	   "https://pastebin.com/api/api_login.php"
	   (list
	    (cons "api_dev_key" api-dev-key)
	    (cons"api_user_name" (quri:url-encode api-user-name))
	    (cons "api_user_password" (quri:url-encode api-user-password))))))
    (if (equal 200 (nth 1 result))
	(nth 0 result)
	result)))

(defun private-code (pc)
  (cond
    ((equal pc :public) "0")
    ((equal pc :unlisted) "1")
    ((equal pc :private) "2")
    (t nil)))

(defun new-paste (api-dev-key api-paste-code
		  &key api-user-key api-paste-name api-paste-format
		    api-paste-private api-paste-expire-date api-folder-key)
  (declare (ignore api-folder-key))
  (let ((private (private-code api-paste-private))
	(options nil))
    (when api-paste-format
      (assert (member api-paste-format *valid-payload-types* :test #'equal)))
    (when api-paste-expire-date
      (assert (member api-paste-expire-date *valid-expire-times* :test #'equal)))
    (when api-paste-private
      (assert (member private (list "0" "1" "2") :test #'equal)))
    (setf options (list
		   (cons "api_option" "paste")
		   (cons "api_dev_key" api-dev-key)
		   (cons "api_paste_code" (quri:url-encode api-paste-code))))
    (when api-user-key
      (setf options
	    (cons (cons "api_user_key" (quri:url-encode api-user-key)) options)))
    (when api-paste-private
      (setf options
	    (cons (cons "api_paste_private" private) options)))
    (when api-paste-name
      (setf options
	    (cons (cons "api_paste_name" (quri:url-encode api-paste-name)) options)))
    (when api-paste-format
      (setf options (cons (cons "api_paste_format" api-paste-format) options)))
    (when api-paste-name
      (setf options
	    (cons (cons "api_paste_name" (quri:url-encode api-paste-name)) options)))
    (when api-paste-expire-date
      (setf options
	    (cons (cons "api_paste_expire_date" api-paste-expire-date) options)))
    (let ((result
	    (api-post
	     "https://pastebin.com/api/api_post.php"
	     options)))
      (if (equal 200 (nth 1 result))
	  (nth 0 result)
	  result))))

(defun list-pastes (api-dev-key api-user-key &optional (api-results-limit 100))
    (let ((result
	    (api-post
	     "https://pastebin.com/api/api_post.php"
	     (list
	      (cons "api_option" "list")
	      (cons "api_dev_key" api-dev-key)
	      (cons "api_user_key" api-user-key)
	      (cons "api_results_limit_key" api-results-limit)))))
      (cond
	((equal "No pastes found." (nth 0 result))
	 (list :empty))
	((equal 200 (nth 1 result))
	 (html-parse:parse-html (nth 0 result)))
	(t
	 result))))

(defun delete-paste (api-dev-key api-user-key api-paste-key)
    (let ((result
	    (api-post
	     "https://pastebin.com/api/api_post.php"
	     (list
	      (cons "api_option" "delete")
	      (cons "api_dev_key" api-dev-key)
	      (cons "api_user_key" api-user-key)
	      (cons "api_paste_key" api-paste-key)))))
      (if (equal "Paste Removed" (nth 0 result))
	 t
	 result)))

(defun user-info (api-dev-key api-user-key)
    (let ((result
	    (api-post
	     "https://pastebin.com/api/api_post.php"
	     (list
	      (cons "api_option" "userdetails")
	      (cons "api_dev_key" api-dev-key)
	      (cons "api_user_key" api-user-key)))))
      (if (equal 200 (nth 1 result))
	  (html-parse:parse-html (nth 0 result))
	  result)))

;;; Local Variables:
;;; mode: Lisp
;;; coding: utf-8
;;; End:

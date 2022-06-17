
Can we embed Djula templates in a self-contained binary?

https://github.com/mmontone/djula/issues/79

see pathes.lisp

eval the last snippet that tries to compile all templates.

erronous output is:

```
Compiling template file /home/vince/bacasable/bacalisp/demo-djula-in-binaries/src/templates/base.html…
Compiling template file /home/vince/bacasable/bacalisp/demo-djula-in-binaries/src/templates/admin.html…; Evaluation aborted on #<TEMPLATE-ERROR "{# Error: There was an error processing the token (TAG EXTENDS base.html) : Template base.html not found #}" {1002B84513}>.


{# Error: There was an error processing the token (TAG EXTENDS base.html) : Template base.html not found #}
```

The template admin.html "extends" base.html.

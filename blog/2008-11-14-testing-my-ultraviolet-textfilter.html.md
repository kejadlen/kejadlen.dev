---
title: Testing my Ultraviolet textfilter
...

A demonstration of code/syntax highlighting in Typo. To install:

```console
$ script/plugin install git://github.com/kejadlen/typo_textfilter_ultraviolet.git
  ```

Some examples:

<div class="UltraViolet">
<pre class="idle">class Foo
  def bar
    puts <span class="String"><span class="String">"</span>hello world<span class="String">"</span></span>
  end
end
</pre>
</div>

C with blackboard theme and line numbers:

<div class="UltraViolet">
<pre class="blackboard"><span class="line-numbers">   1 </span> <span class="Storage">void</span> bar() {
<span class="line-numbers">   2 </span>   <span class="Support">printf</span>(<span class="String"><span class="String">"</span>hello world<span class="Constant">\n</span><span class="String">"</span></span>);
<span class="line-numbers">   3 </span> }
</pre>
</div>

Objective-C with the idle theme:

<div class="UltraViolet">
<pre class="idle">#<span class="Keyword">import</span> <span class="String"><span class="String">&lt;</span>Foundation/NSObject.h<span class="String">&gt;</span></span>

<span class="Storage"><span class="Storage">@</span>interface</span> <span class="TypeName">Fraction</span>: <span class="InheritedClass">NSObject</span> {
    <span class="Storage">int</span> numerator;
    <span class="Storage">int</span> denominator;
}

-(<span class="Storage">void</span>) <span class="FunctionName">print</span>;
-(<span class="Storage">void</span>) <span class="FunctionName">setNumerator</span><span class="FunctionName"><span class="FunctionName">:</span></span> (<span class="Storage">int</span>) <span class="FunctionArgument">d</span>;
-(<span class="Storage">void</span>) <span class="FunctionName">setDenominator</span><span class="FunctionName"><span class="FunctionName">:</span></span> (<span class="Storage">int</span>) <span class="FunctionArgument">d</span>;
-(<span class="Storage">int</span>) <span class="FunctionName">numerator</span>;
-(<span class="Storage">int</span>) <span class="FunctionName">denominator</span>;
<span class="Storage"><span class="Storage">@</span>end</span>
</pre>
</div>

<script type="text/javascript">
var head = document.getElementsByTagName('head')[0];
var link = document.createElement('link');
link.rel = 'stylesheet';
link.href = '/assets/{{ page.title | slugify}}/blackboard.css';
head.appendChild(link);
var link = document.createElement('link');
link.rel = 'stylesheet';
link.href = '/assets/{{ page.title | slugify}}/idle.css';
head.appendChild(link);
</script>

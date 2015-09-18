<p>This is the content of <code><?php echo $appconf; ?></code>:</p>
<pre class="pre-scrollable">
<?php echo htmlentities(file_get_contents($appconf), ENT_QUOTES|ENT_SUBSTITUTE); ?>
</pre>
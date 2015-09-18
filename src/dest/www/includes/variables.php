<?php 
$app = "aria2";
$appname = "Aria2";
$appversion = "1.17.1-2";
$appsite = "http://aria2.sourceforge.net/";
$apphelp = "http://aria2.sourceforge.net/manual/en/html/index.html";

$applogs = array("/tmp/DroboApps/".$app."/log.txt",
                 "/tmp/DroboApps/".$app."/aria2.log",
                 "/tmp/DroboApps/".$app."/access.log",
                 "/tmp/DroboApps/".$app."/error.log");
$appconf = "/mnt/DroboFS/Shares/DroboApps/".$app."/etc/".$app.".conf";

$appprotos = array("http", "tcp");
$appports = array("6880", "6800");
$droboip = $_SERVER['SERVER_ADDR'];
$apppage = $appprotos[0]."://".$droboip.":".$appports[0]."/";
if ($publicip != "") {
  $publicurl = $appprotos[0]."://".$publicip.":".$appports[0]."/";
} else {
  $publicurl = $appprotos[0]."://public.ip.address.here:".$appports[0]."/";
}
$portscansite = "http://mxtoolbox.com/SuperTool.aspx?action=scan%3a".$publicip."&run=toolpage";
?>

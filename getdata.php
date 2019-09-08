<?
	include("config.inc.php");

	switch ($_GET["P"]) {
		case 'D': echo gmdate("d.m.Y H:i:s"); break;
		case 'V': echo $CurrentVersion; break;
		case 'F': {
			header("Content-Disposition: attachment; filename=atsetup.exe");
			header("Content-Type: application/octet-stream");
			header("Content-Length: " . filesize($SetupFile));
			readfile($SetupFile);
		}
		break;
		case 'U': {
			header("Content-Disposition: attachment; filename=atupdate.exe");
			header("Content-Type: application/octet-stream");
			header("Content-Length: " . filesize($UpdateFile));
			readfile($UpdateFile);
		}
		break;
	}

	exit;
?>

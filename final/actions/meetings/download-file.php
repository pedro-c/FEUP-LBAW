<?php

header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename='.$_REQUEST['f']);
readfile('../../images/files/'.$_REQUEST['f']);
exit;
<?php
#
# PeakListSplit.php
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

//--------------------------------------------------------------------
//	PeakListSplitの起動
//--------------------------------------------------------------------

	$execDir = dirname(__FILE__);
	$execDir .= "/" . include("${execDir}/NowVersion.php");

	if(chdir($execDir) == false){
		exit(1);
	}
	include("./" . basename(__FILE__));
?>

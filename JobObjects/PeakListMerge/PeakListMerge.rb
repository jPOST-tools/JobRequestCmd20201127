# encoding: utf-8
#
# PeakListMerge.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	PeakListMergeの起動
-----------------------------------------------------------------------------
=end
	execDir = File.dirname(__FILE__)
	execProg = File.basename(__FILE__)

	require("#{execDir}/NowVersion.rb")

	Dir.chdir("#{execDir}/" + MyVersion.getVersion())
	load("./#{execProg}")


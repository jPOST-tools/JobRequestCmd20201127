# encoding: utf-8
#
# Configure.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	ProteoWizPlistConst

	ProteoWizardPlistWで使用する定数を管理。
-----------------------------------------------------------------------------
=end

module PW_PLISTWConst
# パラメータへのアクセスキー

	PRO_WIZ_PL_W_PEP_TOL = 'ProteoWizardPlistW.PeptideTol'
	PRO_WIZ_PL_W_PEP_TOL_U = 'ProteoWizardPlistW.PeptideTolUnit'


	TOL_U_PPM = 'ppm'
	TOL_U_DA = 'Da'

	MS_CONVERT_PATH = '../../ProteoWizard/ProteoWizard 3.0.4449/msconvert.exe'
	SEARCH_MONO_ISO_CMD = '../SearchMonoIsotope/SearchMonoIsotope/bin/Debug/SearchMonoIsotope.exe'

end


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

	ProteoWizardPlistで使用する定数を管理。
-----------------------------------------------------------------------------
=end

module ProteoWizPlistConst
# パラメータへのアクセスキー

	PRO_WIZ_PL_PEP_TOL = 'ProteoWizardPlist.PeptideTol'
	PRO_WIZ_PL_PEP_TOL_U = 'ProteoWizardPlist.PeptideTolUnit'


	TOL_U_PPM = 'ppm'
	TOL_U_DA = 'Da'

#	MS_CONVERT_PATH = '../../ProteoWizard/ProteoWizard 3.0.4462/msconvert.exe'
#	MS_CONVERT_PATH = '../../ProteoWizard/ProteoWizard 3.0.4449/msconvert.exe'
#	MS_CONVERT_PATH = '../../ProteoWizard/ProteoWizard 3.0.6715/msconvert.exe'
	MS_CONVERT_PATH = '../../ProteoWizard/ProteoWizard 3.0.11018/msconvert.exe'
	MS_READER_LOG = '../log/MsReaderLog.txt'
end


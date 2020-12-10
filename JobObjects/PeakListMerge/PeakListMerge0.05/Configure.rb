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
	PLMerConst

	PeakListMergeで使用する定数を管理。
-----------------------------------------------------------------------------
=end

module PeakListMerge
# パラメータへのアクセスキー

	PLM_PEP_TOL = 'PeakListMerge.PeptideTol'
	PLM_PEP_TOL_U = 'PeakListMerge.PeptideTolUnit'
	PLM_MS2_SELECT_IN = 'PeakListMerge.Ms2SelectIn'
	PLM_MS2_MIN_INT = 'PeakListMerge.Ms2MinInt'

	PLM_TOL_U_PPM = 'ppm'
	PLM_TOL_U_DA = 'Da'

	PLM_MS_TYPE_AB = 'wiff'
	PLM_MS_TYPE_THERMO = 'raw'

	PLM_MS2_SELECT_PILOT = 'Pilot'
	PLM_MS2_SELECT_MSCON = 'MSconverter'
	PLM_MS2_SELECT_MAXQ = 'MaxQuant'
	PLM_MS2_SELECT_WIZD = 'Wizd'
	PLM_MS2_SELECT_DSCO = 'Dsco'


end


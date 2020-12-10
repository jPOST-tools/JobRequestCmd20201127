# encoding: utf-8
#
# GetParamData.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	GetParamData.rb

	PeakListMergeで使用するパラメータ定義の定数を登録する。
-----------------------------------------------------------------------------
=end

require("./Configure.rb");

class MyParamData
	def MyParamData.getParamData()
		rtc = Hash.new()

		myObjName = JobObjName::PEAKLIST_MERGE


# Jobのヘッダー情報
		wkAry = Hash.new()

		wkAry[Pconst::P_JOB_OBJ_HELP] = 'Merge multiple peak lists.'
		wkAry[Pconst::P_EXEC_CMD] = [
			ReqFileType::TYPE_PEAK_LIST,
			{
				Pconst::JOB_CMD_DEFAULT => [
					"PeakListMerge/PeakListMerge.rb",
					Pconst::JOB_GR_DEFAULT
				]
			}
		]
		wkAry[Pconst::P_IN_FILE] = {
			ReqFileType::TYPE_PEAK_LIST => [
				[
					ReqFileType::TYPE_PEAK_LIST,
				],
				Pconst::CRT_IN_MULTI,
				"inFileCountCheckA",
			]
		};
		wkAry[Pconst::P_OUT_FILE] = {
			ReqFileType::TYPE_PEAK_LIST => [
				ReqFileType::TYPE_PEAK_LIST,
				nil,
				"%s.txt",
			]

		}

		rtc[Pconst::P_PARAM] = Hash.new()
		rtc[Pconst::P_PARAM][myObjName] = wkAry


# 起動時のパラメータの定義
		wkAry = nil
		wkAry = Array.new()

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_ITEM] = wkAry;


		wkAry.push([
			PeakListMerge::PLM_PEP_TOL,
			'Peptide tol. &plusmn;', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 50
			}
		])

		wkAry.push([
			PeakListMerge::PLM_PEP_TOL_U,
			'Peptide tol(Unit)','%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[PeakListMerge::PLM_TOL_U_DA,PeakListMerge::PLM_TOL_U_DA],
				[PeakListMerge::PLM_TOL_U_PPM,PeakListMerge::PLM_TOL_U_PPM],
			],
			{}
		])

		wkAry.push([
			PeakListMerge::PLM_MS2_SELECT_IN,
			'MS2 select','%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[PeakListMerge::PLM_MS2_SELECT_PILOT,PeakListMerge::PLM_MS2_SELECT_PILOT],
				[PeakListMerge::PLM_MS2_SELECT_MSCON,PeakListMerge::PLM_MS2_SELECT_MSCON],
				[PeakListMerge::PLM_MS2_SELECT_MAXQ,PeakListMerge::PLM_MS2_SELECT_MAXQ],
				[PeakListMerge::PLM_MS2_SELECT_WIZD,PeakListMerge::PLM_MS2_SELECT_WIZD],
				[PeakListMerge::PLM_MS2_SELECT_DSCO,PeakListMerge::PLM_MS2_SELECT_DSCO],
			],
			{}
		])

		wkAry.push([
			PeakListMerge::PLM_MS2_MIN_INT,
			'MS2 min intensity', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 50
			}
		])

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_ITEM] = wkAry;


# パラメータの横並びの定義
		wkAry = nil
		wkAry = Hash.new()

		wkAry[PeakListMerge::PLM_PEP_TOL] = PeakListMerge::PLM_PEP_TOL_U

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_JOINT] = wkAry


# パラメータのランチャー情報
		wkAry = nil
		wkAry = Array.new()

		initPara = {
			PeakListMerge::PLM_PEP_TOL => '20',
			PeakListMerge::PLM_PEP_TOL_U => PeakListMerge::PLM_TOL_U_PPM,
			PeakListMerge::PLM_MS2_SELECT_IN => PeakListMerge::PLM_MS2_SELECT_MAXQ,
			PeakListMerge::PLM_MS2_MIN_INT => '0',
		}

		initPara1 = initPara.clone()
		initPara1[PeakListMerge::PLM_MS2_SELECT_IN] = PeakListMerge::PLM_MS2_SELECT_PILOT
		initPara1[PeakListMerge::PLM_MS2_MIN_INT] = '20.01'

		initPara2 = initPara.clone()
		initPara2[PeakListMerge::PLM_MS2_SELECT_IN] = PeakListMerge::PLM_MS2_SELECT_MSCON
		initPara2[PeakListMerge::PLM_MS2_MIN_INT] = '20.01'


		wkAry.push(['Default',initPara])
		wkAry.push(['Q-Exactive',initPara])
		wkAry.push(['TT5600',initPara1])
		wkAry.push(['jPOSTwiff',initPara2])


		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_LANCHER] = wkAry
		initPara = nil
		wkAry = nil

		return rtc;
	end
end

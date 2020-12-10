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

	ProteoWizardPlistで使用するパラメータ定義の定数を登録する。
-----------------------------------------------------------------------------
=end

require("./Configure.rb");

class MyParamData
	def MyParamData.getParamData()
		rtc = Hash.new()

		myObjName = JobObjName::PROTEO_WIZ_PLIST_W


# Jobのヘッダー情報
		wkAry = Hash.new()

		wkAry[Pconst::P_JOB_OBJ_HELP] = 'Peak list making uses ProteoWizard.'
		wkAry[Pconst::P_EXEC_CMD] = [
			ReqFileType::TYPE_RAW_DATA,
			{
				Pconst::JOB_CMD_DEFAULT => [
					"ProteoWizardPlistW/ProteoWizardPlistW.rb",
#					Pconst::JOB_GR_DEFAULT
					Pconst::JOB_GR_OTHRE_PC
				]
			}
		]
		wkAry[Pconst::P_IN_FILE] = {
			ReqFileType::TYPE_RAW_DATA => [
				[
					ReqFileType::TYPE_QSTAR,
					ReqFileType::TYPE_QSTAR_SCAN,
				],
				Pconst::CRT_IN_MULTI,
				"inFileCountCheckA",
			]
		};
		wkAry[Pconst::P_OUT_FILE] = {
			ReqFileType::TYPE_PEAK_LIST => [
				ReqFileType::TYPE_PEAK_LIST_MASCOT,
				nil,
				"%s.wizd.txt",
			]
		}

		rtc[Pconst::P_PARAM] = Hash.new()
		rtc[Pconst::P_PARAM][myObjName] = wkAry


# 起動時のパラメータの定義
		wkAry = nil
		wkAry = Array.new()

		wkAry.push([
			PW_PLISTWConst::PRO_WIZ_PL_W_PEP_TOL,
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
			PW_PLISTWConst::PRO_WIZ_PL_W_PEP_TOL_U,
			'Peptide tol(Unit)','%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				['ppm',PW_PLISTWConst::TOL_U_PPM],
				['Da',PW_PLISTWConst::TOL_U_DA]
			],
			{}
		])

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_ITEM] = wkAry;


# パラメータの横並びの定義
		wkAry = nil
		wkAry = Hash.new()
		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_JOINT] = wkAry


# パラメータのランチャー情報
		wkAry = nil
		wkAry = Array.new()

		initPara = {
			PW_PLISTWConst::PRO_WIZ_PL_W_PEP_TOL => '9',
			PW_PLISTWConst::PRO_WIZ_PL_W_PEP_TOL_U => PW_PLISTWConst::TOL_U_PPM,
		}

		wkAry.push(['Default',initPara]);

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_LANCHER] = wkAry
		initPara = nil
		wkAry = nil

		return rtc;
	end
end

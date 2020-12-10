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

		myObjName = JobObjName::PROTEO_WIZ_PLIST


# Jobのヘッダー情報
		wkAry = Hash.new()

		wkAry[Pconst::P_JOB_OBJ_HELP] = 'Peak list making uses ProteoWizard.'
		wkAry[Pconst::P_EXEC_CMD] = [
			ReqFileType::TYPE_RAW_DATA,
			{
				Pconst::JOB_CMD_DEFAULT => [
					"ProteoWizardPlist/ProteoWizardPlist.rb",
#					Pconst::JOB_GR_DEFAULT
					Pconst::JOB_GR_OTHRE_PC
				]
			}
		]
		wkAry[Pconst::P_IN_FILE] = {
			ReqFileType::TYPE_RAW_DATA => [
				[
					ReqFileType::TYPE_LCQ,
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
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL,
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
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL_U,
			'Peptide tol(Unit)','%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				['ppm',ProteoWizPlistConst::TOL_U_PPM],
				['Da',ProteoWizPlistConst::TOL_U_DA]
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
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL => '0.05',
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL_U => ProteoWizPlistConst::TOL_U_DA,
		}

		wkAry.push(['LCQ,LTQ',initPara]);

		initPara1 = initPara.clone()
		initPara1 = {
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL => '0.03',
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL_U => ProteoWizPlistConst::TOL_U_DA,
		}

		wkAry.push(['Orbi',initPara1]);

		initPara2 = initPara.clone()
		initPara2 = {
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL => '8',
			ProteoWizPlistConst::PRO_WIZ_PL_PEP_TOL_U => ProteoWizPlistConst::TOL_U_PPM,
		}

		wkAry.push(['Q-Exactive',initPara2]);

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_LANCHER] = wkAry
		initPara = nil
		wkAry = nil

		return rtc;
	end
end

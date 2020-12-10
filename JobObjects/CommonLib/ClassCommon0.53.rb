# encoding: utf-8
#
# ClassCommonX.XX.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
//------------------------------------------------------------------
	Module Pconst

	JobRequest-Rubyプログラムで使用する共通定数を登録する
//------------------------------------------------------------------
=end

module Pconst
# システムのConfFile
	P_JOBREQ_CONF_FILE = '../../../ConfFiles/JobRequestConf.json'

# ConfFileの項目へのアクセスキー
	P_RUBY_DIR = 'RubyDir'
	P_PHP_DIR = 'PHPdir'
	P_NODE_CTL_HOST = 'NodeControlHost'
	P_NODE_CTL_PROC_MON_PORT = 'NodeControlProcMonPort'
	P_NODE_CTL_CPU_ASS_PORT = 'NodeControlCpuAssPort'
	P_NODE_CTL_JOB_PROGRESS_PORT = 'NodeControlJobProgressPort'
	P_NODE_CTL_PROC_INFO_PORT = 'NodeControlProcInfoPort'

	P_USE_RS_RUBY = 'UseRSruby'
	P_NODE_RS_RUBY_DIR = 'NodeRSruby_RubyDir'
	P_NODE_RUBY_DIR = 'NodeRubyDir'
	P_NODE_PHP_DIR = 'NodePHPdir'

	P_NODE_CTL_NODES_CONFIG = 'NodesConfig'
	P_SSH_USER_NAME = 'SSH_userName'
	P_MASCOT_VER = 'MascotVersion'

# 各JobObjにて定義が必要な項目
	P_PARAM = "Param"
	P_JOB_OBJ_HELP = "JobObjHelp"
	P_EXEC_CMD = "ExecCmd"
	P_PARAM_ITEM = "ParamItem"
	P_PARAM_JOINT = "ParamJoint"
	P_PARAM_DISABLE = "ParamDisable"
	P_PARAM_LANCHER = "ParamLancher"
	P_IN_FILE = "InFile"
	P_OUT_FILE = "OutFile"
	P_TEMP_FILE = "TempFile"
	P_STDOUT_FILE = "StdoutFile"
	P_SPLIT_FILE = "SplitFile"
	P_BEFORE_JOB_KEY = "BeforeJobKey"
	P_MANUAL_INPUT_FILE = "ManualInputFile"
	P_JOB_COUNT_OPTION = "JobCountOption"

# 分割するJobの動作の種類
	P_SPLIT_PARAM_SET_COUNT_EXEC = "SplitParamSetCountExec"

# Jobのテンプレートで定義が必要な項目
	P_EXEC_JOB = "ExecJob"
	P_JOB_CONT_EXEC = "JobContExec"
	P_JOB_FIX_NODE = "JobContFixNode"
	P_JOB_CONT_RETRY = "JobContRetry"

# ひとまとまりのJobが受けつける入力ファイル数
	CRT_IN_MULTI = "CrtInFileMulti"

# １つの実行単位のJobが出力するファイル数
	RESULT_SPLIT = "ResultSplit"

# Jobをどう動かすかの定義が必要な項目
	EXEC_ONLY_ONE = "ExecOnlyOne"
	EXEC_FILE_NUM = "ExecFileNum"
	EXEC_FILE_NUM_JOB_KYES = "ExecFileNumJobKeys"

# 各パラメータの想定するinput type
	TYPE_SELECT = "select"
	TYPE_TEXT = "text"
	TYPE_LIST = "list"
	TYPE_CHECKBOX = "checkbox"
	TYPE_HIDDEN = "hidden"
	TYPE_TREE = "tree"

# パラメータがtextの場合の入力エリアのsizeを取り出すキーワード
	KEY_SIZE_VAL = "RawSize"

# パラメータがselectの場合の表示エリアのsizeを取り出すキーワード
	KEY_SEL_SIZE_VAL = "SelSize"

# パラメータの入力チェックのパターンを示す定数
	IN_CHK_EMP_OK = "EmptyOk"
	IN_CHK_REQUIRED = "Required"

# Job起動時のコマンドを決めるときのデフォルト値のキーワード
	JOB_CMD_DEFAULT = "JobCmdDef"

# Jobグループの種類の定義
	JOB_GR_DEFAULT = "JobGrDefault"
	JOB_GR_OTHRE_PC = "JobGrOtherPC"

# Jobを管理するフォルダー名
	JOB_TEMP_DIR = "../../../temp"


# Job要求ファイル、JobParam.php内のヘッダー情報へのキーワード
	P_JOB_HEADER = "JobHeader"
	P_JOB_STATUS_FILE = "JobStatusFile"
	P_JOB_EXEC_HOST = "JobExecHost"

# JobParam.phpをJsonに変換してくれるPHPプログラム
	P_JOB_PARAM_TO_JSON = '../../bin/JobParamToJson.php'
	P_JOB_PARAM_TO_JSON_R = '../../bin/JobObjParamDump.rb'

# 各オブジェクトで定義するファイル
	OBJ_VERSION_FILE = 'NowVersion.%s'
	OBJ_PARAM_FILE = 'GetParamData.%s'

# 複数ノードで実行時に必要な定数
	SSH_CMD_PATH = "ssh"
	SCP_CMD_PATH = "scp"
	JOB_NODE_EXEC_PATH = "JobRequest/JobObjects/bin/binExecDir"
	TYPE_TANDEM_RESULT = "TandemResult"
	JOB_RESULT_DIR = "../../../ResultFiles"

# 結果を格納するフォルダーの区切り文字
	RESULT_DIR_SEP = '^'

end


=begin
//------------------------------------------------------------------
//	Class JobObjName
//
//	JobReqObjで必要なオブジェクトの名前を定義する。
//------------------------------------------------------------------
=end

class JobObjName
# オブジェクト名の定義
				# 処理の種類.オブジェクト名
	MASCOT_EXEC		= "Psearch.MascotExec"

	XCALIBUR_PLIST		= "PeakList.XcaliburPlist"
	ANALIST_PLIST		= "PeakList.AnalystPlist"
	PROTEO_WIZ_PLIST	= "PeakList.ProteoWizardPlist"
	PROTEO_WIZ_PLIST_W	= "PeakList.ProteoWizardPlistW"
	PROTEO_WIZ_CID_HCD	= "PeakList.ProteoWizardCidHcd"
	MULTIPLE_PLIST_W	= "PeakList.MultiplePeakListW"
	MULTIPLE_PLIST		= "PeakList.MultiplePeakList"
	PRO_PILOT_PLIST		= "PeakList.ProteinPilotPlist"
	MAX_QUANT_PLIST		= "PeakList.MaxQuantPlist"
	MAX_QUANT_PLIST_W	= "PeakList.MaxQuantPlistW"
	MAX_QUANT_PL_CID_HCD	= "PeakList.MaxQuantPlistCidHcd"
	DISCOVERER_PLIST	= "PeakList.DiscovererPlist"
	DISCOVERER_PL_CID_HCD	= "PeakList.DiscovererPlistCidHcd"
	ML_PEAK_LIST_RAW	= "PeakList.ML_PeakListRaw"
	ML_PEAK_LIST_NPZ	= "PeakList.ML_PeakListNpz"
	ML_PEP_LIST_TO_NPZ	= "PeakList.ML_PepListToNpz"
	PEAKLIST_HIT_SUB	= "PeakList.PeakListHitSub"
	PEAKLIST_MERGE		= "PeakList.PeakListMerge"

	PRO_PILOT_EXEC		= "Psearch.ProteinPilotExec"
	PRO_PILOT_FILTER	= "Psearch.ProteinPilotFilter"
	MAX_QUANT_EXEC		= "Psearch.MaxQuantExec"
	MAX_QUANT_FILTER	= "Psearch.MaxQuantFilter"
	COMET_EXEC		= "Psearch.CometExec"
	COMET_FILTER		= "Psearch.CometFilter"

	XCALIBUR_PEP_QUANT	= "Quant.XcaliburPepQuant"
	WIFF_PEP_QUANT		= "Quant.WiffPepQuant"
	ITRAQ_QUANT		= "Quant.ItraqQuant"
	ITRAQ_MS3_QUANT		= "Quant.ItraqMs3Quant"
	SKYLINE_QUANT		= "Quant.SkylineQuant"
	SKYLINE_FILTER		= "Quant.SkylineFilter"

	INSERT_DUMMY_SEQ	= "Tool.InsertDummySeq"
	INSERT_DUMMY_SEQ_L	= "Tool.InsertDummySeqLerp"
	SEEDTOP_EXEC		= "Tool.SeedtopExec"
	STE_TO_PINFO		= "Tool.SeedtopExecToPinfo"
	DIS_SEARCH_RESULT	= "Tool.DistinctSearchResult"
	PRECURSOR_PURIFY	= "Tool.PrecursorPurifyInfo"

end


=begin
//------------------------------------------------------------------
//	Class ReqFileType
//
//	入力対象のファイルタイプを定義する。
//------------------------------------------------------------------
=end

class ReqFileType
# 生データの種類
	TYPE_RAW_DATA = 'RawData'	# 全体の総称
	TYPE_LCQ = 'FileLCQ'		# 個別の種類
	TYPE_QSTAR = 'FileQSTAR'
	TYPE_QSTAR_SCAN = 'FileQSTARscan.RawExt'

# ピークリストの種類
	TYPE_PEAK_LIST = 'PeakList'	# 全体の総称
	TYPE_PEAK_LIST_MASCOT = 'PeakList_Mascot'	# 個別の種類

# サーチエンジンの結果ファイルの種類
	TYPE_PPILOT_RESULT = 'ProPilotResult'
	TYPE_PPILOT_RESULT_XML = 'ProPilotResultXml'
	TYPE_PPILOT_RESULT_MZID = 'ProPilotResultMzid'
	TYPE_PPILOT_RESULT_TXT = 'ProPilotResultTxt'
	TYPE_MAX_Q_RESULT = 'MaxQuantResult'
	TYPE_MAX_Q_PARA = 'MaxQuantParaFile'
	TYPE_MAX_Q_PRO_GR = 'MaxQuantProteinGr'
	TYPE_COMET_RESULT = 'CometResult'

# CSVファイルの種類
	TYPE_TEXT_CSV = 'Text_CSV'		# 全体の総称
	TYPE_FILTER_RESULT = 'FilterResult'	# 個別の種類
	TYPE_M_FLT_Q_THERMO = 'MascotFilterQuantThermo'
	TYPE_A_FLT_Q_ITRAQ = 'AllFilterQuantItraq'
	TYPE_PPILOT_R_PRO_SUMMARY = 'ProPilotResult_ProteinSummary'

# Skylineの特殊ファイルの定義
	TYPE_SKYLINE_XML = 'SkylineXML'
	TYPE_SKYLINE_SKYD = 'SkylineSkyd'
	TYPE_SKYLINE_BLIB = 'SkylineBlib'

# Jsonファイルの種類
	TYPE_TEXT_JSON = 'Text_JSON'		# 全体の総称
	TYPE_SEEDTOP_RESULT = 'SeedtopResult'	# 個別の種類

# CsvTitleに付加情報を追加するときのセパレータ
	CSV_TITLE_SEP = ':' 

# TandemFilterで必要なタイトル
	CSV_RAW_DATA_FILE = 'RawdataFile'
	CSV_PEAK_LIST_FILE = 'PeakListFile'
	CSV_PEPT_EXPT = 'PeptExpt'
	CSV_CALC_MZ = 'CalcMz'
	CSV_CALC_MASS = 'CalcMass'
	CSV_CHARGE = 'Charge'
	CSV_BEFORE_SEQ = 'FwdSeq'
	CSV_SEQ = 'Seq'
	CSV_BEHIND_SEQ = 'BwdSeq'
	CSV_MOD = 'Mod'
	CSV_MOD_DETAIL = 'ModDetail'
	CSV_RET_TIME = 'RetTime'
	CSV_PEAK_COMMENT = 'Title'
	CSV_PRECURSOR_INT = 'PrecursorIntensity'
	CSV_DB_NAME = 'DBname'

# CSVファイルのタイトル文字の定義
	CSV_NO = 'no'

# XcaliburPepQuantで必要なタイトル
	CSV_PEP_RATIO = 'Ratio'
	CSV_PEP_RATIO_SD = 'LH_RatioSD'
	CSV_PEP_INT = 'PepIntensity'
	CSV_PEP_AREA = 'PepArea'
	CSV_PEP_TARGET_MZ = 'PepTargetMz'
	CSV_PEP_RT_START = 'PepRtimeStart'
	CSV_PEP_RT_PEAK = 'PepRtimePeak'
	CSV_PEP_RT_END = 'PepRtimeEnd'
	CSV_PEP_SMOOTH_COUNT = 'PepSmoothCount'
	CSV_PEP_PEAK_COUNT = 'PepPeakCount'
	CSV_PEP_TIC_RT = 'PepTicRtime'
	CSV_PEP_TIC_INT = 'PepTicInt'
	CSV_PEP_TIC_INT_RAW = 'PepTicIntRaw'
	CSV_PEP_HALF_WIDTH = 'PepHalfWidth'
	CSV_PEP_PRE_INFO_MZ = 'PepPreInfoMz'
	CSV_PEP_PRE_INFO_INT = 'PepPreInfoInt'
	CSV_PEP_SYMMETRY_FACT = 'PepSymmetryFacter'

# SkylineQuantで必要なタイトル
	CSV_ISOTOPE_DOTP = 'IsotopeDotp'

# InsertDummySeqで必要なタイトル
	CSV_DUMMY_SEQ = 'DummySeq'
	CSV_MULTI_RTIME_GROUP = 'MultiRtimeGroup'
	CSV_IDENT_FILE_NM = 'IdentFileName'

# Itraq定量で必要なタイトル
	CSV_QUANT_ITRAQ = 'iTRAQ:%s'
	CSV_QUANT_ITRAQ_MS3 = 'QuantMs3scanNo'

# SeedtopExecToPinfoで必要なタイトル
	CSV_DB_KEY_NAME = 'AccNum'
	CSV_PROT_NAME = 'ProtDescription'
#	CSV_MAIN_DB_KEY_NUM = 'MainProteinIDNum'
#	CSV_MAIN_DB_KEY_IDS = 'MainProteinIDs'
	CSV_DB_KEY_ID_NUM = 'ProteinIDNum'
	CSV_DB_KEY_IDS = 'ProteinIDs'
	CSV_PROT_NAMES = 'ProteinNames'
	CSV_GENE_NAMES = 'GeneNames'
	CSV_UNIPROT_IDS = 'UniprotIDs'
	CSV_PEP_SEQS = 'PeptideSeqs'
	CSV_SEQ_COVERAGE = 'SeqCoverage[%}'
	CSV_SEQ_LENGTH = 'SeqLength'
	CSV_HIT_PEP_NUM = 'PeptidesNum'
	CSV_UNQ_PEP_NUM = 'UniquePeptidesNum'
	CSV_HIT_PEP_NUM_FILE = 'PeptidesNum:'
	CSV_UNQ_PEP_NUM_FILE = 'UniquePeptidesNum:'

# UnimodToCsvで必要なタイトル
	CSV_UNI_MOD_R_ID = "RecordID"
	CSV_UNI_MOD_TITLE = "ModTitle"
	CSV_UNI_POSTTION = "Position"
	CSV_UNI_SITE = "Site"
	CSV_UNI_CLASSIFICATION = "Classification"
	CSV_UNI_COMPOSITION = "Composition"
	CSV_UNI_MONO_MASS = "MonoMass"
	CSV_UNI_AVGE_MASS = "AvgeMass"
	CSV_UNI_N_LOSS_MONO_MASS = "NeutralLossMonoMass"
	CSV_UNI_N_LOSS_AVGE_MASS = "NeutralLossAvgeMass"
	CSV_UNI_N_LOSS_COMPOSITION = "NeutralLossComposition"

# ProteinPilotFilterで必要なタイトル
	CSV_OBS_MASS = 'ObsMass'
	CSV_OBS_MZ = 'ObsMz'
	CSV_DELTA_MASS = 'DeltaMass'
	CSV_PROT_MASS = 'ProtMass'
	CSV_PROT_SCORE = 'ProtScore'
	CSV_PROT_EXPT = 'ProtExpt'
	CSV_PRPT_COUNT = 'PeptCnt'
	CSV_PEPT_SCORE = 'PeptScore'
	CSV_DELTA_SCORE = 'DeltaScore'
	CSV_MISS_CLVG = 'MissClvg'
	CSV_SEARCH_ENGINE = 'Engine'
	CSV_PEPT_HOMO = 'PeptHomo'
	CSV_PEPT_ID = 'PeptID'
	CSV_PEPT_BOLD = 'PeptBold'
	CSV_PEPT_RED = 'PeptRed'
	CSV_PEPT_CHECK = 'PeptCheck'
	CSV_PEPT_PARENT = 'PeptsParet'
	CSV_RESULT_URL = 'ResultURL'
	CSV_PROT_URL = 'ProtURL'
	CSV_PEPTS_URL = 'PeptsURL'
	CSV_PEPTS_URL_LORIKEET = 'PeptsURL_lorikeet'
	CSV_3D_PEAK_VIEW = '3D_PeakView'
	CSV_UNIPROT_URL = 'UniprotURL'
	CSV_IDENTITY = 'Identity'
	CSV_GENE_SYMBOL = 'GeneSymbol'
	CSV_GENE_DESC = 'GeneDescription'
	CSV_TYPE_OF_GENE = 'TypeOfGene'
	CSV_MAP_LOCATION = 'MapLocation'
	CSV_PROTEIN_SEQ = 'ProteinSeq'
	CSV_MULTI_HIT_NUM = 'MultiHitNum'

# DistinctSearchResultで必要なタイトル
	CSV_SCAN_NO = 'ScanNo'
	CSV_PL_HIT_COUNT = 'PeakListHitCount'
	CSV_ENG_HIT_COUNT = 'EngHitCount'
	CSV_PL_ENG_HIT_SCORE = 'PL_EngHitScore'
	CSV_JPOST_SCORE = 'jPostScore'
	CSV_M_FLAG_DETAIL = 'MatchFlagDetail'
	CSV_M_FLAG_COUNT = 'MatchFlagCount'
	CSV_HIT_PART_SEQ = 'HitPartSeq'
	CSV_M_FLAG_INT_P = 'MatchFlagInt%'
	CSV_M_FLAG_INT_SUM = 'MatchFlagIntSum'

end

=begin
//------------------------------------------------------------------
	Module PepHitConst

	PepHitViewで使用する定数を定義する。
//------------------------------------------------------------------
=end

module PepHitConst
# Get変数へのアクセスキー
	GET_FILE = 'file'
	GET_LINE_NO = 'lineNo'
	GET_MASS_ERROR = 'massErr'
	GET_MASS_ERROR_UNIT = 'massErrU'
	GET_MS2_NUM = 'ms2Num'
	GET_PRE_ERROR = 'preErr'
	GET_PRE_ERROR_UNIT = 'preErrU'

	PEP_HIT_VIEW = 'ProteoAnalysis/PepHitView.php'
	PEP_HIT_VIEW_RB = 'ProteoAnalysis/PepHitView.rb'
	MS_PEAK_VIEW = 'MsPeakView/MsPeakView.php?inRawFile=%s&smoothLevel=5&smoothCount=1&hitMZ=%.4f&mzRange=0.02&hitRtime=%f&charge=%d&title='
end

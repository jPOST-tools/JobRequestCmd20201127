<?php
#
# ClassCommonX.XX.php
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

//------------------------------------------------------------------
//	Class Pconst
//
//	パラメータ定義の共通クラス。。
//	全オブジェクトで共通して使用する定数を登録する。
//------------------------------------------------------------------
class Pconst{
// システム全体の改行コード
	const NEW_LINE = "\r\n";

// システムのConfFile
	const P_JOBREQ_CONF_FILE = '../../../ConfFiles/JobRequestConf.json';
	const P_PROG_CONF_DIR = '../../../ConfFiles/LancherConf';
	const P_LANCHER_CONF_DIR = '../../../ConfFiles/ProgConf';

// Rubyで出来ているGetParamData.rbをJsonにして読み出すプログラム
	const P_JOB_OBJ_PARAM_TO_JSON = '../../bin/JobObjParamDump.rb';

// ConfFileの項目へのアクセスキー
	const P_RUBY_DIR = 'RubyDir';
	const P_PHP_DIR = 'PHPdir';
	const P_PERL_DIR = 'PerlDir';
	const P_NODE_CTL_HOST = 'NodeControlHost';
	const P_NODE_CTL_JOB_PRGR_PORT = 'NodeControlJobProgressPort';
	const P_NODE_CTL_PROC_INFO_PORT = 'NodeControlProcInfoPort';
	const BACKUP_DISK_PATH = 'BackupDiskPath';

// 各JobObjにて定義が必要な項目
	const P_PARAM = "Param";
	const P_JOB_OBJ_HELP = "JobObjHelp";
	const P_EXEC_CMD = "ExecCmd";
	const P_PARAM_ITEM = "ParamItem";
	const P_PARAM_JOINT = "ParamJoint";
	const P_PARAM_DISABLE = "ParamDisable";
	const P_PARAM_LANCHER = "ParamLancher";
	const P_IN_FILE = "InFile";
	const P_OUT_FILE = "OutFile";
	const P_TEMP_FILE = "TempFile";
	const P_STDOUT_FILE = "StdoutFile";
	const P_SPLIT_FILE = "SplitFile";
	const P_BEFORE_JOB_KEY = "BeforeJobKey";
	const P_MANUAL_INPUT_FILE = "ManualInputFile";
	const P_JOB_COUNT_OPTION = "JobCountOption";

// 分割するJobの動作の種類
	const P_SPLIT_PARAM_SET_COUNT_EXEC = "SplitParamSetCountExec";
	const P_SPLIT_RESULT_FILE = "SplitResultFile";

// 特殊な入力チェックのパターンの項目
	const P_CHK_SAME_AMINO_NG = "ChkSameAminoNG";

// ひとまとまりのJobが受けつける入力ファイル数
	const CRT_IN_SINGLE = "CrtInSingle";
	const CRT_IN_MULTI = "CrtInFileMulti";

// １つの実行単位のJobが受けつける入力ファイル数
//	const JOB_IN_FILE_SINGLE = "JobInFileSingle";
//	const JOB_IN_FILE_MULTI = "JobInFileMulti";

// １つの実行単位のJobが出力するファイル数
	const RESULT_SPLIT = "ResultSplit";

// Jobのテンプレートで定義が必要な項目
	const P_JOB_TEMPLATE = "JobTemplate";
	const P_EXEC_JOB = "ExecJob";
	const P_JOB_CONT_EXEC = "JobContExec";
//	const P_JOB_CONT_START = "JobContStart";
	const P_JOB_CONT_RETRY = "JobContRetry";
//	const P_JOB_FIX_NODE = "JobContFixNode";
	const P_PARAM_SAME_VAL = "ParamSameVal";
	const P_PARAM_ALL_SET_LANCHER = "ParamAllSetLancher";

// JobTemplate.phpで定義が必要な項目
	const P_PROG_CHECK = "_ProgCheck";
	const P_FILE_TYPE_TREE = "FileTypeTree";

// Jobをどう動かすかの定義が必要な項目
	const EXEC_ONLY_ONE = "ExecOnlyOne";
	const EXEC_FILE_NUM = "ExecFileNum";
	const EXEC_FILE_NUM_JOB_KYES = "ExecFileNumJobKeys";

// EXEC_ONLY_ONEの時に出力ファイルをどうするかの定義
	const EXEC_OUT_FILE_ARRAY = "ExecOutFileArray";
	const EXEC_OUT_FILE_ONE = "ExecOutFileOne";

// Jobを開始させるときの条件
	const READY_IN_FILE = "ReadyInFile";
	const NO_CHECK_START = "NoCheckStart";

// Jobをリトライさせるときの条件
//	const JOB_ERR_EXIT = "JobErrorExit";

// Jobをノード指定で実行させる定義
	const NODE_FILE_SERVER = "NodeFileServer";

// Jobの入力ファイルの定義
	const CONST_FILE = "ConstFile";

// Jobの入出力ファイルの存在場所の定義
//	const INPUT_FILE = "InputFile";
//	const OUT_FOLDER = "OutFolder";
//	const PARAM_FOLDER = "ParamFolder";

// Jobの出力ファイル名の決め方の可変部分の定義が必要な項目
//	const IN_FILE_FULL = "InFileFull";
//	const IN_FILE_NO_EXT = "InFileNoExt";
//	const JOB_NAME_KEY = "JobNameKey";
//	const JOB_SPLIT_KEY = "JobSplitKey";
//	const JOB_NO_STR = "JobNoStr";

// 各パラメータの想定するinput type
	const TYPE_SELECT = "select";
	const TYPE_TEXT = "text";
	const TYPE_LIST = "list";
	const TYPE_CHECKBOX = "checkbox";
	const TYPE_HIDDEN = "hidden";
	const TYPE_TREE = "tree";

// パラメータがtextの場合の入力エリアのsizeを取り出すキーワード
	const KEY_SIZE_VAL = "RawSize";
	const KEY_COL_SIZE_VAL = "ColSize";

// パラメータがselectの場合の表示エリアのsizeを取り出すキーワード
	const KEY_SEL_SIZE_VAL = "SelSize";

// パラメータの入力チェックのパターンを示す定数
	const IN_CHK_EMP_OK = "EmptyOk";
	const IN_CHK_REQUIRED = "Required";

// Job起動時のコマンドを決めるときのデフォルト値のキーワード
	const JOB_CMD_DEFAULT = "JobCmdDef";

// Jobグループの種類の定義
	const JOB_GR_MASCOT = "JobGrMascot";
	const JOB_GR_ANALYST = "JobGrAnalyst";
	const JOB_GR_DEFAULT = "JobGrDefault";

// Jobを管理するフォルダー名
	const JOB_FILE_DIR = "../../../JobFiles";
	const JOB_WAIT_DIR = "Wait";
	const JOB_RESULT_DIR = "../../../ResultFiles";
	const JOB_TEMP_DIR = "../../../temp";

// Jobの実行管理時に使用するファイル
	const JOB_PARAM_FILE = "JobParam.php";
	const JOB_STATUS_FILE = "JobStatus.json";
	const JOB_CONTROL_STDOUT_FILE = "JobScheduleMonitor_StdoutErr.txt";

// Jobを分割するときにJobParam.phpで追加される項目
	const OUT_FILE_TEMPLATE = "OutFileTemplate";

// Job要求ファイル、JobParam.php内のヘッダー情報へのキーワード
	const P_JOB_HEADER = "JobHeader";
	const P_JOB_ID = "JobID";
	const P_MAIL_ADRESS = "MailAdress";
	const P_JOB_COMMENT = "JobComment";
	const P_REQ_HOST = "ReqHostName";
	const P_JOB_CONTROL_PROG = "JobControlProg";
	const P_JOB_PARAM_FILE = "JobParamFile";
	const P_JOB_STATUS_FILE = "JobStatusFile";
	const P_JOB_CONTROL_STDOUT = "JobControlStdout";
	const P_REQ_TIME = "ReqTime";
	const P_JOB_EXEC_HOST = "JobExecHost";
	const P_RESULT_DIR = "ResultDir";
	const P_JOB_START_TIME = "JobStartTime";
	const P_JOB_FILES_DIR = "JobFilesDir";

// JobStatusFileRead.phpで作成するJobParam.phpに追加するキーワード
	const P_STATUS_FILE_NAME = "StatusFileName";

// JobFiles/Waitのdirで読み込み対象のファイルの拡張子
	const P_TARGET_EXT_JSON = "json";

// 各オブジェクトで定義するファイル
	const OBJ_VERSION_FILE = "NowVersion.php";
	const OBJ_PARAM_FILE = "GetParamData.php";

// 結果を格納するフォルダーの区切り文字
	const RESULT_DIR_SEP = '^';

// サーチエンジンのタイプの識別文字
	const S_ENG_MASCOT = 'Mascot';
	const S_ENG_TANDEM = 'X!Tandem';

}

//------------------------------------------------------------------
//	Class JobObjName
//
//	JobReqObjで必要なオブジェクトの名前を定義する。
//------------------------------------------------------------------
class JobObjName{
// オブジェクト名の定義
				// 処理の種類.オブジェクト名
	const RAW_FILES_COPY		= "CloudTools.RawFilesCopy";
	const RESULT_FILES_COPY		= "CloudTools.ResultFilesCopy";

	const MSPP_PLIST		= "PeakList.MassPPplist";
	const TPP_PLIST			= "PeakList.TPP_plist";
	const LCMS8030_PLIST		= "PeakList.LCMS8030plist";
	const AXIMA_PLIST_MERGE		= "PeakList.AximaPlistMerge";
	const PEAKLIST_SPLIT		= "PeakList.PeakListSplit";
	const XCALIBUR_PLIST		= "PeakList.XcaliburPlist";
	const ANALIST_PLIST		= "PeakList.AnalystPlist";
	const PROTEO_WIZ_PLIST		= "PeakList.ProteoWizardPlist";
	const PROTEO_WIZ_PLIST_W	= "PeakList.ProteoWizardPlistW";
	const MULTIPLE_PLIST_W		= "PeakList.MultiplePeakListW";
	const MULTIPLE_PLIST		= "PeakList.MultiplePeakList";
	const PRO_PILOT_PLIST		= "PeakList.ProteinPilotPlist";
	const MAX_QUANT_PLIST		= "PeakList.MaxQuantPlist";
	const MAX_QUANT_PLIST_W		= "PeakList.MaxQuantPlistW";
	const DISCOVERER_PLIST		= "PeakList.DiscovererPlist";

	const TANDEM_EXEC		= "Psearch.TandemExec";
	const TANDEM_FILTER		= "Psearch.TandemFilter";
	const MASCOT_EXEC		= "Psearch.MascotExec";
	const MASCOT_FILTER		= "Psearch.MascotFilter";
	const RE_PROTEIN_SEARCH		= "Psearch.ReProteinSearch";
	const PRO_PILOT_EXEC		= "Psearch.ProteinPilotExec";
	const PRO_PILOT_FILTER		= "Psearch.ProteinPilotFilter";
	const MAX_QUANT_EXEC		= "Psearch.MaxQuantExec";
	const MAX_QUANT_FILTER		= "Psearch.MaxQuantFilter";
	const COMET_EXEC		= "Psearch.CometExec";
	const COMET_FILTER		= "Psearch.CometFilter";

	const XCALIBUR_PEP_QUANT	= "Quant.XcaliburPepQuant";
	const XOME_QUANT		= "Quant.XomeQuant";
	const WIFF_PEP_QUANT		= "Quant.WiffPepQuant";
	const ITRAQ_QUANT		= "Quant.ItraqQuant";
	const SKYLINE_QUANT		= "Quant.SkylineQuant";
	const SKYLINE_FILTER		= "Quant.SkylineFilter";

	const PEP_ANNOTATION		= "Annotation.PepAnnotation";
	const PROTEIN_ANNOTATION	= "Annotation.ProteinAnnotation";

	const BLAST_SPLIT		= "Tool.BlastSplit";
	const BLAST_SEARCH		= "Tool.BlastSearch";
	const SEEDTOP_SEARCH		= "Tool.SeedtopSearch";
	const SEEDTOP_EXEC		= "Tool.SeedtopExec";
	const DB_KEY_TO_GENE_SYMBOL	= "Tool.DBkeyToGeneSymbol";
	const SEEDTOP_RES_TO_PINFO	= "Tool.SeedtopResultToProtInfo";
	const STE_TO_PINFO		= "Tool.SeedtopExecToPinfo";
	const PEPSEQ_TO_MOL_WEIGHT	= "Tool.PepSeqToMolWeight";
	const PROTSEQ_TO_PEP_WEIGHT	= "Tool.ProtSeqToPepWeight";
	const CALC_FRAGMENT_ION		= "Tool.CalcFragmentIon";
	const MSPP_CMD			= "Tool.MsppCmd";
	const CSV_FILE_MERGE		= "Tool.CsvFileMerge";
	const SEARCH_SEQ_MOD_PT		= "Tool.SearchSeqModPoint";
	const INSERT_DUMMY_SEQ		= "Tool.InsertDummySeq";
	const INSERT_DUMMY_SEQ_L	= "Tool.InsertDummySeqLerp";
}

//------------------------------------------------------------------
//	Class ReqFileType
//
//	入力対象のファイルタイプを定義する。
//------------------------------------------------------------------
class ReqFileType{
// 生データの種類
	const TYPE_RAW_DATA = 'RawData';	// 全体の総称
	const TYPE_LCQ = 'FileLCQ';		// 個別の種類
	const TYPE_QSTAR = 'FileQSTAR';
	const TYPE_MASS_NAVI = 'FileMassNavi';
	const TYPE_MASS_PP = 'FileMassPP';
	const TYPE_MZ_XML = 'FileMzXML';
	const TYPE_LCMS8030_DUMP = 'FileLCMS8030dump';
	const TYPE_AXIMA = 'FileAxima';

	const TYPE_RAW_EXT = 'RawExt';		// 生データの拡張
	const TYPE_AXIMA_EXT = 'FileAxima.RawExt';
	const TYPE_QSTAR_SCAN = 'FileQSTARscan.RawExt';

// ピークリストの種類
	const TYPE_PEAK_LIST = 'PeakList';		// 全体の総称
	const TYPE_PEAK_LIST_MASCOT = 'PeakList_Mascot';// 個別の種類
	const TYPE_PEAK_LIST_DTA = 'PeakList_DTA';
	const TYPE_PEAK_LIST_DIR = 'PeakList_DIR';
	const TYPE_ACD_FRAGMENT = 'ACD_Fragmenter';


// サーチエンジンの結果ファイルの種類
	const TYPE_TANDEM_RESULT = 'TandemResult';
	const TYPE_MASCOT_RESULT = 'MascotResult';
	const TYPE_OMSSA_RESULT = 'OmssaResult';
	const TYPE_PPILOT_RESULT = 'ProPilotResult';
	const TYPE_PPILOT_RESULT_XML = 'ProPilotResultXml';
	const TYPE_PPILOT_RESULT_TXT = 'ProPilotResultTxt';
	const TYPE_MAX_Q_RESULT = 'MaxQuantResult';
	const TYPE_MAX_Q_PARA = 'MaxQuantParaFile';
	const TYPE_MAX_Q_PRO_GR = 'MaxQuantProteinGr';
	const TYPE_COMET_RESULT = 'CometResult';

// テキストファイル（ダウンロードしたデータベース）の種類
	const TYPE_TEXT_FASTA = 'Text_Fasta';
	const TYPE_DAT_SWPROT = 'Dat_Swprot';

// テキストファイル（プログラムで使用するもの）の種類
	const TYPE_MSPP_PLIST_INI = 'MsppPlistIni';
	const TYPE_BLAST_RESULT = 'BlastResult';
	const TYPE_TANDEM_PARAM = 'TandemParam';
	const TYPE_TANDEM_TAXON = 'TandemTaxon';
	const TYPE_TANDEM_RESIDUES = 'TandemResidues';
	const TYPE_BLAST_IN_SEQ = 'BlastInSeq';

// テキストファイル（Jobコントロール関連）の種類
	const TYPE_JOB_SPLIT_RESULT = 'JobSplitResult';
	const TYPE_PARAM_FILE = 'ParamFile';
	const TYPE_STATUS_FILE = 'StatusFile';
	const TYPE_STDOUT = 'StdOutFile';

// CSVファイルの種類
	const TYPE_TEXT_CSV = 'Text_CSV';		// 全体の総称
	const TYPE_FILTER_RESULT = 'FilterResult';	// 個別の種類
	const TYPE_PEP_ANNOTATION = 'PepAnnotation';
	const TYPE_PEP_ANNOTATION_MOD = 'PepAnnotationMod';
	const TYPE_PROTEIN_RESULT = 'ProteinResult';
	const TYPE_PROTEIN_ANNOTATION = 'ProteinAnnotation';
	const TYPE_MASCOT_FILTER = 'MascotFilter';
	const TYPE_TANDEM_FILTER = 'TandemFilter';

	const TYPE_M_FLT_Q_WIFF = 'MascotFilterQuantWiff';
	const TYPE_T_FLT_Q_WIFF = 'TandemFilterQuantWiff';
	const TYPE_M_FLT_Q_THERMO = 'MascotFilterQuantThermo';
	const TYPE_T_FLT_Q_THERMO = 'TandemFilterQuantThermo';
	const TYPE_A_FLT_Q_ITRAQ = 'AllFilterQuantItraq';
	const TYPE_PPILOT_R_PRO_SUMMARY = 'ProPilotResult_ProteinSummary';
	const TYPE_SKYLINE_XML = 'SkylineXML';
	const TYPE_SKYLINE_BLIB = 'SkylineBlib';



// Jsonファイルの種類
	const TYPE_TEXT_JSON = 'Text_JSON';		// 全体の総称
	const JSON_TYPE_KEY = 'FileType';// Jsonファイルのタイプを示すHashキー
	const JSON_DATA_KEY = 'Data';		// データ本体を示すHashキー
	const TYPE_SEEDTOP_RESULT = 'SeedtopResult';	// 個別の種類

// 機器設定ファイルの種類
	const TYPE_QSTAT_DAB = 'Qstar_dab';
	const TYPE_LCQ_SLD = 'Lcq_sld';

// パッケージプログラム関連のファイル
	const TYPE_EXCEL_XLSX = 'Excel_xlsx';
	const TYPE_ZIP = 'Type_Zip';

// フォルダー関連の種類
	const TYPE_DIR = 'Dir';
	const TYPE_NOT_FOUND = 'NotFound';

// CsvTitleに付加情報を追加するときのセパレータ
	const CSV_TITLE_SEP = ':' ;


// CSVファイルのタイトル文字の定義
	const CSV_NO = 'no';

// TandemFilterで必要なタイトル
	const CSV_RAW_DATA_FILE = 'RawdataFile';
	const CSV_PEAK_LIST_FILE = 'PeakListFile';
	const CSV_PROT_URL = 'ProtURL';
	const CSV_PEPTS_URL = 'PeptsURL';
	const CSV_PEPTS_URL_LORIKEET = 'PeptsURL_lorikeet';
	const CSV_UNIPROT_URL = 'UniprotURL';
	const CSV_DB_KEY_NAME = 'AccNum';
//	const CSV_PROT_NAME = 'ProtName';
	const CSV_PROT_NAME = 'ProtDescription';
	const CSV_PROTEIN_SEQ = 'ProteinSeq';
	const CSV_GENE_SYMBOL = 'GeneSymbol';
	const CSV_MAP_LOCATION = 'MapLocation';
	const CSV_GENE_DESC = 'GeneDescription';
	const CSV_TYPE_OF_GENE = 'TypeOfGene';
	const CSV_GO_FUNC = 'GO(Function)';
	const CSV_GO_COMP = 'GO(Component)';
	const CSV_GO_PRO = 'GO(Process)';
	const CSV_PROT_EXPT = 'ProtExpt';
	const CSV_PEPT_EXPT = 'PeptExpt';
	const CSV_PEPT_SCORE = 'PeptScore';
	const CSV_OBS_MZ = 'ObsMz';
	const CSV_CALC_MZ = 'CalcMz';
	const CSV_OBS_MASS = 'ObsMass';
	const CSV_CALC_MASS = 'CalcMass';
	const CSV_DELTA_MASS = 'DeltaMass';
	const CSV_CHARGE = 'Charge';
	const CSV_START_POS = 'StartPos';
	const CSV_END_POS = 'EndPos';
	const CSV_BEFORE_SEQ = 'FwdSeq';
	const CSV_SEQ = 'Seq';
	const CSV_BEHIND_SEQ = 'BwdSeq';
	const CSV_MOD = 'Mod';
	const CSV_DOUBLE_MOD_PT = 'DoubleModPosition';
	const CSV_SP_KNOWN_MOD = 'SprotKnownModPosition';
	const CSV_OTHER_MOD_PT = 'OtherModPosition';
	const CSV_MOD_DETAIL = 'ModDetail';
	const CSV_MUTATION_DETAIL = 'MutationDetail';
	const CSV_JURNAL_INFO = 'JournalInfo';
	const CSV_RET_TIME = 'RetTime';
	const CSV_WELL_NO = 'WellNo';
	const CSV_PEAK_COMMENT = 'Title';
	const CSV_DECOY_PEPT_EXPT = 'DecoyPeptExpt';
	const CSV_DECOY_SEQ = 'DecoySeq';
	const CSV_SPEC_MZ = 'SpectrumMZ';
	const CSV_SPEC_INT = 'SpectrumInt';
	const CSV_MZ_LOW_RANGE = 'MzLowRange';
	const CSV_MZ_HIGH_RANGE = 'MzHighRange';
	const CSV_PRECURSOR_INT = 'PrecursorIntensity';
//	const CSV_TANDEM_DB_TYPE = 'TandemDBtype';
	const CSV_DB_NAME = 'DBname';
	const CSV_PROT_MASS = 'ProtMass';
	const CSV_PROT_SCORE = 'ProtScore';
	const CSV_PRPT_COUNT = 'PeptCnt';
	const CSV_DELTA_SCORE = 'DeltaScore';
	const CSV_MISS_CLVG = 'MissClvg';
	const CSV_SEARCH_ENGINE = 'Engine';
	const CSV_PEPT_HOMO = 'PeptHomo';
	const CSV_PEPT_ID = 'PeptID';
	const CSV_PEPT_BOLD = 'PeptBold';
	const CSV_PEPT_RED = 'PeptRed';
	const CSV_PEPT_CHECK = 'PeptCheck';
	const CSV_PEPT_PARENT = 'PeptsParet';
	const CSV_RESULT_URL = 'ResultURL';
	const CSV_IDENTITY = 'Identity';
	const CSV_MULTI_HIT_NUM = 'MultiHitNum';


// DBkeyToGeneSymbolで使用のタイトル
	const CSV_MATCH_SP_FT_INFO = 'MatchSprot-FTinfo';
	const CSV_POTEN_SP_FT_INFO = 'PotentialSprot-FTinfo';


// XcaliburPepQuantで必要なタイトル
	const CSV_PEP_RATIO = 'Ratio';
	const CSV_PEP_INT = 'PepIntensity';
	const CSV_PEP_AREA = 'PepArea';
	const CSV_PEP_TARGET_MZ = 'PepTargetMz';
	const CSV_PEP_RT_START = 'PepRtimeStart';
	const CSV_PEP_RT_PEAK = 'PepRtimePeak';
	const CSV_PEP_RT_END = 'PepRtimeEnd';
	const CSV_PEP_SMOOTH_COUNT = 'PepSmoothCount';
	const CSV_PEP_PEAK_COUNT = 'PepPeakCount';
	const CSV_PEP_TIC_RT = 'PepTicRtime';
	const CSV_PEP_TIC_INT = 'PepTicInt';
	const CSV_PEP_TIC_INT_RAW = 'PepTicIntRaw';
	const CSV_PEP_HALF_WIDTH = 'PepHalfWidth';
	const CSV_PEP_PRE_INFO_MZ = 'PepPreInfoMz';
	const CSV_PEP_PRE_INFO_INT = 'PepPreInfoInt';
	const CSV_PEP_SYMMETRY_FACT = 'PepSymmetryFacter';

// SkylineQuantで必要なタイトル
	const CSV_ISOTOPE_DOTP = 'IsotopeDotp';

// InsertDummySeqで必要なタイトル
	const CSV_DUMMY_SEQ = 'DummySeq';
	const CSV_MULTI_RTIME_GROUP = 'MultiRtimeGroup';

// Xome-Quantで必要なタイトル
	const CSV_XM_PEPT_RES_ID = 'PeptResId';
	const CSV_XM_L_OR_H = 'HorL';
	const CSV_XM_RATIO = 'Ratio (H/L)';
	const CSV_XM_AREA_L = 'Area(L)';
	const CSV_XM_AREA_H = 'Area(H)';
	const CSV_XM_PK_RT_L = 'PeakRT(L)';
	const CSV_XM_PK_RT_H = 'PeakRT(H)';
	const CSV_XM_HEIGHT_L = 'Height(L)';
	const CSV_XM_HEIGHT_H = 'Height(H)';
	const CSV_XM_FWHM_L = 'FWHM(L)';
	const CSV_XM_FWHM_H = 'FWHM(H)';
	const CSV_XM_LOW = 'Low';
	const CSV_XM_HIGH = 'High';
	const CSV_XM_BWD_MZ = 'BwdMz';
	const CSV_XM_FWD_MZ = 'FwdMz';
	const CSV_XM_BWD_RT = 'BwdRT';
	const CSV_XM_FWD_RT = 'FwdRT';
	const CSV_XM_PAIR_MZ = 'PairMz';
	const CSV_XM_SMOOTH = 'Smoothing';
	const CSV_XM_BL_SBRT = 'BLineSbrt';
	const CSV_XM_WS_METD = 'WsMethod';
	const CSV_XM_Q_SCORE = 'QuanScore';
	const CSV_XM_INT_H = 'Int(L)';
	const CSV_XM_INT_L = 'Int(H)';
	const CSV_XM_INT_RATIO = 'IntRatio(H/L)';
	const CSV_XM_AREA_SC_H = 'AreaScore(H)';
	const CSV_XM_AREA_SC_L = 'AreaScore(L)';
	const CSV_XM_REJECT = 'Reject';
	const CSV_XM_RECAL = 'Recalculation';
	const CSV_XM_STATUS = 'Status';

// SeedtopResultToProtInfoで必要なタイトル
	const CSV_SEQ_COUNT = 'SeqCount';
	const CSV_UNIQUE_SEQ_COUNT = 'UniqueSeqCount';
	const CSV_SIMILAR_DBKEY = 'SimilarDBkey';
	const CSV_SEQS_STR = 'SeqStr';

// PepSeqToMolWeightとProtSeqToPepWeightで必要なタイトル
	const CSV_MOL_WEIGHT = 'MolecularWeight';
	const CSV_AMINO_NUM = 'AminoN(%s)';
	const CSV_MZ_CHARGE = 'mz(+%d)';
	const CSV_PI = 'pI';
	const CSV_CLOGP = 'ClogP';
	const CSV_KYTE_DOOLITTLE = 'KyteDoolittle';
	const CSV_BB_INDEX = 'BBindex';

// UnimodToCsvで必要なタイトル
	const CSV_UNI_MOD_R_ID = "RecordID";
	const CSV_UNI_MOD_TITLE = "ModTitle";
	const CSV_UNI_POSTTION = "Position";
	const CSV_UNI_SITE = "Site";
	const CSV_UNI_CLASSIFICATION = "Classification";
	const CSV_UNI_COMPOSITION = "Composition";
	const CSV_UNI_MONO_MASS = "MonoMass";
	const CSV_UNI_AVGE_MASS = "AvgeMass";
	const CSV_UNI_N_LOSS_MONO_MASS = "NeutralLossMonoMass";
	const CSV_UNI_N_LOSS_AVGE_MASS = "NeutralLossAvgeMass";
	const CSV_UNI_N_LOSS_COMPOSITION = "NeutralLossComposition";
	const CSV_UNI_MASCOT_MOD = "MascotMod";

	private $csvTitle;
	private $fileTree;

	function __construct(){
		$this->fileTree = array(
	// 自分のファイルタイプ => 親のファイルタイプ
	ReqFileType::TYPE_RAW_DATA => "",
	ReqFileType::TYPE_LCQ => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_QSTAR => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_MASS_NAVI => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_MASS_PP => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_MZ_XML => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_LCMS8030_DUMP => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_AXIMA => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_AXIMA_EXT => ReqFileType::TYPE_RAW_DATA,
	ReqFileType::TYPE_QSTAR_SCAN => ReqFileType::TYPE_RAW_DATA,

	ReqFileType::TYPE_PEAK_LIST => "",
	ReqFileType::TYPE_PEAK_LIST_MASCOT => ReqFileType::TYPE_PEAK_LIST,
	ReqFileType::TYPE_PEAK_LIST_DTA => ReqFileType::TYPE_PEAK_LIST,
	ReqFileType::TYPE_PEAK_LIST_DIR => ReqFileType::TYPE_PEAK_LIST,
	ReqFileType::TYPE_ACD_FRAGMENT => ReqFileType::TYPE_PEAK_LIST,

	ReqFileType::TYPE_TANDEM_RESULT => "",
	ReqFileType::TYPE_MASCOT_RESULT => "",
	ReqFileType::TYPE_OMSSA_RESULT => "",
	ReqFileType::TYPE_COMET_RESULT => "",
	ReqFileType::TYPE_PPILOT_RESULT_XML => "",

	ReqFileType::TYPE_TEXT_FASTA => "",
	ReqFileType::TYPE_DAT_SWPROT => "",

	ReqFileType::TYPE_MSPP_PLIST_INI => "",
	ReqFileType::TYPE_BLAST_RESULT => "",
	ReqFileType::TYPE_TANDEM_PARAM => "",
	ReqFileType::TYPE_BLAST_IN_SEQ => "",

	ReqFileType::TYPE_JOB_SPLIT_RESULT => "",
	ReqFileType::TYPE_PARAM_FILE => "",
	ReqFileType::TYPE_STATUS_FILE => "",

	ReqFileType::TYPE_MAX_Q_RESULT => "",
	ReqFileType::TYPE_MAX_Q_PARA => "",
	ReqFileType::TYPE_MAX_Q_PRO_GR => "",

	ReqFileType::TYPE_TEXT_CSV => "",
	ReqFileType::TYPE_FILTER_RESULT => ReqFileType::TYPE_TEXT_CSV,
	ReqFileType::TYPE_PEP_ANNOTATION => ReqFileType::TYPE_TEXT_CSV,
	ReqFileType::TYPE_PEP_ANNOTATION_MOD => ReqFileType::TYPE_TEXT_CSV,
	ReqFileType::TYPE_PROTEIN_RESULT => ReqFileType::TYPE_TEXT_CSV,
	ReqFileType::TYPE_PROTEIN_ANNOTATION => ReqFileType::TYPE_TEXT_CSV,

	ReqFileType::TYPE_MASCOT_FILTER => ReqFileType::TYPE_FILTER_RESULT,
	ReqFileType::TYPE_TANDEM_FILTER => ReqFileType::TYPE_FILTER_RESULT,

	ReqFileType::TYPE_QSTAT_DAB => "",
	ReqFileType::TYPE_LCQ_SLD => "",

	ReqFileType::TYPE_EXCEL_XLSX => "",

	ReqFileType::TYPE_SKYLINE_XML => "",
	ReqFileType::TYPE_SKYLINE_BLIB => "",

		);

		$mascotFilterTitle = array(
			ReqFileType::CSV_NO,
			ReqFileType::CSV_DB_KEY_NAME,
			ReqFileType::CSV_PROT_NAME,
			ReqFileType::CSV_PROT_MASS,
			ReqFileType::CSV_PROT_SCORE,
			ReqFileType::CSV_PROT_EXPT,
			ReqFileType::CSV_PRPT_COUNT,
			ReqFileType::CSV_SEQ,
			ReqFileType::CSV_MOD,
			ReqFileType::CSV_MOD_DETAIL,
			ReqFileType::CSV_OBS_MASS,
			ReqFileType::CSV_OBS_MZ,
			ReqFileType::CSV_CALC_MASS,
			ReqFileType::CSV_CALC_MZ,
			ReqFileType::CSV_DELTA_MASS,
			ReqFileType::CSV_CHARGE,
			ReqFileType::CSV_PEPT_SCORE,
			ReqFileType::CSV_DELTA_SCORE,
			ReqFileType::CSV_PEPT_EXPT,
			ReqFileType::CSV_PEAK_COMMENT,
			ReqFileType::CSV_RET_TIME,
			ReqFileType::CSV_MISS_CLVG,
			ReqFileType::CSV_SEARCH_ENGINE,
			ReqFileType::CSV_PEPT_HOMO,
			ReqFileType::CSV_PEPT_ID,
			ReqFileType::CSV_PEPT_BOLD,
			ReqFileType::CSV_PEPT_RED,
			ReqFileType::CSV_PEPT_CHECK,
			ReqFileType::CSV_PEPT_PARENT,
			ReqFileType::CSV_RESULT_URL,
			ReqFileType::CSV_PROT_URL,
			ReqFileType::CSV_PEPTS_URL,
			ReqFileType::CSV_UNIPROT_URL,
			ReqFileType::CSV_IDENTITY,
			ReqFileType::CSV_BEFORE_SEQ,
			ReqFileType::CSV_BEHIND_SEQ,
			ReqFileType::CSV_PEAK_LIST_FILE,
			ReqFileType::CSV_RAW_DATA_FILE,
			ReqFileType::CSV_GENE_SYMBOL,
			ReqFileType::CSV_GENE_DESC,
			ReqFileType::CSV_TYPE_OF_GENE,
			ReqFileType::CSV_GO_FUNC,
			ReqFileType::CSV_GO_COMP,
			ReqFileType::CSV_GO_PRO,
			ReqFileType::CSV_DB_NAME,
			ReqFileType::CSV_MAP_LOCATION,
			ReqFileType::CSV_PROTEIN_SEQ,
			ReqFileType::CSV_PRECURSOR_INT,
			ReqFileType::CSV_MULTI_HIT_NUM,
			ReqFileType::CSV_PEPTS_URL_LORIKEET,
//			ReqFileType::CSV_START_POS,
//			ReqFileType::CSV_END_POS,
//			ReqFileType::CSV_WELL_NO,
//			ReqFileType::CSV_SPEC_MZ,
//			ReqFileType::CSV_SPEC_INT,
//			ReqFileType::CSV_MZ_LOW_RANGE,
//			ReqFileType::CSV_MZ_HIGH_RANGE,
		);

		$tandemFilterTitle = array(
			ReqFileType::CSV_NO,
			ReqFileType::CSV_DB_KEY_NAME,
			ReqFileType::CSV_PROT_NAME,
			ReqFileType::CSV_PROT_MASS,
			ReqFileType::CSV_PROT_EXPT,
			ReqFileType::CSV_PRPT_COUNT,
			ReqFileType::CSV_SEQ,
			ReqFileType::CSV_MOD,
			ReqFileType::CSV_MOD_DETAIL,
			ReqFileType::CSV_OBS_MASS,
			ReqFileType::CSV_OBS_MZ,
			ReqFileType::CSV_CALC_MASS,
			ReqFileType::CSV_CALC_MZ,
			ReqFileType::CSV_DELTA_MASS,
			ReqFileType::CSV_CHARGE,
			ReqFileType::CSV_PEPT_SCORE,
			ReqFileType::CSV_PEPT_EXPT,
			ReqFileType::CSV_PEAK_COMMENT,
			ReqFileType::CSV_RET_TIME,
			ReqFileType::CSV_SEARCH_ENGINE,
			ReqFileType::CSV_PROT_URL,
			ReqFileType::CSV_PEPTS_URL,
			ReqFileType::CSV_UNIPROT_URL,
			ReqFileType::CSV_BEFORE_SEQ,
			ReqFileType::CSV_BEHIND_SEQ,
			ReqFileType::CSV_PEAK_LIST_FILE,
			ReqFileType::CSV_RAW_DATA_FILE,
//			ReqFileType::CSV_TANDEM_DB_TYPE,
			ReqFileType::CSV_DB_NAME,
			ReqFileType::CSV_GENE_SYMBOL,
			ReqFileType::CSV_GENE_DESC,
			ReqFileType::CSV_TYPE_OF_GENE,
			ReqFileType::CSV_GO_FUNC,
			ReqFileType::CSV_GO_COMP,
			ReqFileType::CSV_GO_PRO,

			ReqFileType::CSV_MAP_LOCATION,
			ReqFileType::CSV_JURNAL_INFO,
			ReqFileType::CSV_PROTEIN_SEQ,

			ReqFileType::CSV_START_POS,
			ReqFileType::CSV_END_POS,
			ReqFileType::CSV_DOUBLE_MOD_PT,
			ReqFileType::CSV_SP_KNOWN_MOD,
			ReqFileType::CSV_OTHER_MOD_PT,
			ReqFileType::CSV_MUTATION_DETAIL,
//			ReqFileType::CSV_MATCH_SP_FT_INFO,
//			ReqFileType::CSV_POTEN_SP_FT_INFO,
			ReqFileType::CSV_PRECURSOR_INT,
			ReqFileType::CSV_WELL_NO,
			ReqFileType::CSV_DECOY_PEPT_EXPT,
			ReqFileType::CSV_DECOY_SEQ,
			ReqFileType::CSV_MULTI_HIT_NUM,
			ReqFileType::CSV_PEPTS_URL_LORIKEET,
//			ReqFileType::CSV_SPEC_MZ,
//			ReqFileType::CSV_SPEC_INT,
//			ReqFileType::CSV_MZ_LOW_RANGE,
//			ReqFileType::CSV_MZ_HIGH_RANGE,
		);

		$thermoQuentTitle = array(
			ReqFileType::CSV_PEP_INT,
			ReqFileType::CSV_PEP_AREA,
			ReqFileType::CSV_PEP_HALF_WIDTH,
			ReqFileType::CSV_PEP_TARGET_MZ,
			ReqFileType::CSV_PEP_RT_START,
			ReqFileType::CSV_PEP_RT_PEAK,
			ReqFileType::CSV_PEP_RT_END,
			ReqFileType::CSV_PEP_SMOOTH_COUNT,
			ReqFileType::CSV_PEP_PEAK_COUNT,
			ReqFileType::CSV_PEP_TIC_RT,
			ReqFileType::CSV_PEP_TIC_INT,
			ReqFileType::CSV_PEP_PRE_INFO_MZ,
			ReqFileType::CSV_PEP_PRE_INFO_INT,
		);

		$wiffQuentTitle = array(
			ReqFileType::CSV_XM_PEPT_RES_ID,
			ReqFileType::CSV_XM_L_OR_H,
			ReqFileType::CSV_XM_RATIO,
			ReqFileType::CSV_XM_AREA_L,
			ReqFileType::CSV_XM_AREA_H,
			ReqFileType::CSV_XM_PK_RT_L,
			ReqFileType::CSV_XM_PK_RT_H,
			ReqFileType::CSV_XM_HEIGHT_L,
			ReqFileType::CSV_XM_HEIGHT_H,
			ReqFileType::CSV_XM_FWHM_L,
			ReqFileType::CSV_XM_FWHM_H,
			ReqFileType::CSV_XM_LOW,
			ReqFileType::CSV_XM_HIGH,
			ReqFileType::CSV_XM_BWD_MZ,
			ReqFileType::CSV_XM_FWD_MZ,
			ReqFileType::CSV_XM_BWD_RT,
			ReqFileType::CSV_XM_FWD_RT,
			ReqFileType::CSV_XM_PAIR_MZ,
			ReqFileType::CSV_XM_SMOOTH,
			ReqFileType::CSV_XM_BL_SBRT,
			ReqFileType::CSV_XM_WS_METD,
			ReqFileType::CSV_XM_Q_SCORE,
			ReqFileType::CSV_XM_INT_H,
			ReqFileType::CSV_XM_INT_L,
			ReqFileType::CSV_XM_INT_RATIO,
			ReqFileType::CSV_XM_AREA_SC_H,
			ReqFileType::CSV_XM_AREA_SC_L,
			ReqFileType::CSV_XM_REJECT,
			ReqFileType::CSV_XM_RECAL,
			ReqFileType::CSV_XM_STATUS,
		);

		$this->csvTitle = array(
			ReqFileType::TYPE_MASCOT_FILTER => $mascotFilterTitle,
			ReqFileType::TYPE_TANDEM_FILTER => $tandemFilterTitle,

			ReqFileType::TYPE_M_FLT_Q_THERMO => array_merge($mascotFilterTitle,$thermoQuentTitle),
			ReqFileType::TYPE_T_FLT_Q_THERMO => array_merge($tandemFilterTitle,$thermoQuentTitle),
			ReqFileType::TYPE_M_FLT_Q_WIFF => array_merge($mascotFilterTitle,$wiffQuentTitle),
			ReqFileType::TYPE_T_FLT_Q_WIFF => array_merge($tandemFilterTitle,$wiffQuentTitle),

			ReqFileType::TYPE_PEP_ANNOTATION => array(
				ReqFileType::CSV_NO,
			),

			ReqFileType::TYPE_PEP_ANNOTATION_MOD => array(
				ReqFileType::CSV_NO,
			),

			ReqFileType::TYPE_PROTEIN_RESULT => array(
				ReqFileType::CSV_NO,
			),

			ReqFileType::TYPE_PROTEIN_ANNOTATION => array(
				ReqFileType::CSV_NO,
			),

		);

	}

	function getCsvTitle($fileType=null){
		if(isset($this->csvTitle) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line = %d : csvTitle is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		if(isset($fileType) == false){
			return $this->csvTitle;
		}
		if(isset($this->csvTitle[$fileType]) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line = %d : csvTitle[$fileType] is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $this->csvTitle[$fileType];
	}

	function getFileTree(){
		if(isset($this->fileTree) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line = %d : fileTree is null.",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		return $this->fileTree;
	}

}

//------------------------------------------------------------------
//	Class CheckFileType
//
//	指定のファイルタイプを判別する。
//------------------------------------------------------------------
class CheckFileType{
	const TXT_CHK_MAX_LINE = 100;

	private $ftypeObj;

	function __construct(){
		$this->ftypeObj = new ReqFileType();
	}

	function checkExtension($fname){
		$wkAry = pathinfo($fname);
		if(isset($wkAry['extension']) == false){
			return '';
		}
		return $wkAry['extension'];
	}

	function checkBaseName($fname){
		$wkAry = pathinfo($fname);
		return $wkAry['filename'];
	}

	function checkCsvType($lstr,$checkPerfect=true){
		$stdTitleAry = $this->ftypeObj->getCsvTitle();
		$titleAry = explode("\t",$lstr);
		foreach($stdTitleAry as $typeKey => $titleAryWk){
			$diffAry1 = array_diff($titleAry,$titleAryWk);
			if(count($diffAry1) > 0){
				continue;
			}
			if($checkPerfect == false){
				return $typeKey;
			}
			$diffAry2 = array_diff($titleAryWk,$titleAry);
			if(count($diffAry2) > 0){
				continue;
			}
			return $typeKey;
		}
		return ReqFileType::TYPE_NOT_FOUND;
	}

	function checkTxtType($fname){
		if(($rfp=fopen($fname,"r")) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : %s : file not found.",__FILE__,__LINE__,$fname) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$lineNo = 0;
		$rtc = null;
		while(feof($rfp) == false){
			if(($lstr=fgets($rfp)) == false){
				continue;
			}
			$lstr = trim($lstr);
			$lineNo++;
			if(strpos($lstr,"SEARCH=") !== false){
				$rtc = ReqFileType::TYPE_PEAK_LIST_MASCOT;
				break;
			}else if(strpos($lstr,"COM=") !== false){
				$rtc = ReqFileType::TYPE_PEAK_LIST_MASCOT;
				break;
			}else if(strpos($lstr,"BEGIN IONS") !== false){
				$rtc = ReqFileType::TYPE_PEAK_LIST_MASCOT;
				break;
			}else if(strpos($lstr,"SPECMAN_ASCII(ACD)") !== false){
				$rtc = ReqFileType::TYPE_ACD_FRAGMENT;
				break;
			}else if(strpos($lstr,"[Header]") !== false){
				$rtc = ReqFileType::TYPE_LCMS8030_DUMP;
				break;
			}else if(substr($lstr,0,1) == '>'){
				$rtc = ReqFileType::TYPE_TEXT_FASTA;
				break;
			}
			if(count(explode("\t",$lstr)) > 1){
				$wkRtc = $this->checkCsvType($lstr);
				if($wkRtc == ReqFileType::TYPE_NOT_FOUND){
					$rtc = ReqFileType::TYPE_TEXT_CSV;
				}else{
					$rtc = $wkRtc;
				}
				break;
			}
			$wkAry = explode(' ',$lstr);
			if(count($wkAry) == 2){
				foreach($wkAry as $val){
					if(is_numeric($val) == false){
						break 2;
					}
				}
				$rtc = ReqFileType::TYPE_PEAK_LIST_DTA;
			}
			if($lineNo >= TXT_CHK_MAX_LINE){
				break;
			}
		}
		fclose($rfp);
//print "lstr=($lstr)";
		if($rtc == null){
//			ErrorTools::ErrorExit(sprintf("%s : Line=%d : This file is not support.(fileName=$fname)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
			$rtc = ReqFileType::TYPE_NOT_FOUND;
		}
		return $rtc;
	}

	function checkXmlType($fname){
		if(($rfp=fopen($fname,"r")) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : %s : file not found.",__FILE__,__LINE__,$fname) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$lineNo = 0;
		$rtc = null;
		while(feof($rfp) == false){
			if(($lstr=fgets($rfp)) == false){
				continue;
			}
			$lstr = trim($lstr);
			$lineNo++;
			if(strpos($lstr,"version=") !== false){
				continue;
			}else if(strpos($lstr,"tandem") !== false){
				$rtc = ReqFileType::TYPE_TANDEM_RESULT;
			}else if(strpos($lstr,"MSResponse") !== false){
				$rtc = ReqFileType::TYPE_OMSSA_RESULT;
			}
			break;
		}
		fclose($rfp);
//print "lstr=($lstr)";
		if($rtc == null){
//			ErrorTools::ErrorExit(sprintf("%s : Line=%d : This file is not support.(fileName=$fname)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
			$rtc = ReqFileType::TYPE_NOT_FOUND;
		}
		return $rtc;
	}

	function checkDatType($fname){
		if(($rfp=fopen($fname,"r")) == false){
			ErrorTools::ErrorExit(sprintf("%s : Line=%d : %s : file not found.",__FILE__,__LINE__,$fname) . ErrorTools::getStackStr(Pconst::NEW_LINE));
		}
		$lineNo = 0;
		$rtc = null;
		while(feof($rfp) == false){
			if(($lstr=fgets($rfp)) == false){
				continue;
			}
			$lstr = trim($lstr);
			$lineNo++;
			if(strpos($lstr,"Generated by Mascot") !== false){
				$rtc = ReqFileType::TYPE_MASCOT_RESULT;
			}else if(strpos($lstr,"ID") === 0){
				$rtc = ReqFileType::TYPE_DAT_SWPROT;
			}
			break;
		}
		fclose($rfp);
//print "lstr=($lstr)";
		if($rtc == null){
//			ErrorTools::ErrorExit(sprintf("%s : Line=%d : This file is not support.(fileName=$fname)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
			$rtc = ReqFileType::TYPE_NOT_FOUND;
		}
		return $rtc;
	}

	function getFileType($fname){
		$ext = strtolower($this->checkExtension($fname));
		if($ext == "wiff"){
			return ReqFileType::TYPE_QSTAR;
		}
		if($ext == "scan"){
			return ReqFileType::TYPE_QSTAR_SCAN;
		}
		if($ext == "raw"){
			return ReqFileType::TYPE_LCQ;
		}
		if($ext == "mnb"){
			return ReqFileType::TYPE_MASS_NAVI;
		}
		if($ext == "msb"){
			return ReqFileType::TYPE_MASS_PP;
		}
		if($ext == "mzxml"){
			return ReqFileType::TYPE_MZ_XML;
		}
		if($ext == "txt"){
			return $this->checkTxtType($fname);
		}
		if($ext == "xml"){
//			return ReqFileType::TYPE_TANDEM_RESULT;
			return $this->checkXmlType($fname);
		}
		if($ext == "mgf"){ // Hitachi-MS
			return ReqFileType::TYPE_PEAK_LIST_MASCOT;
		}
		if($ext == "dat"){ // Swprot-dat or MascotResult
			return $this->checkDatType($fname);
		}
		if($ext == "sld"){ // Lcqのsldファイル
			return ReqFileType::TYPE_LCQ_SLD;
		}
		if($ext == "dab"){ // Qstarのdabファイル
			return ReqFileType::TYPE_QSTAT_DAB;
		}
		if($ext == "xlsx"){ // Excel_xlsxのファイル
			return ReqFileType::TYPE_EXCEL_XLSX;
		}
		if($ext == "run"){ // Aximaのファイル
			return ReqFileType::TYPE_AXIMA;
		}
		if($ext == "cal"){ // AximaのExtファイル
			return ReqFileType::TYPE_AXIMA_EXT;
		}
		if($ext == "stats"){ // AximaのExtファイル
			return ReqFileType::TYPE_AXIMA_EXT;
		}
		if(is_dir($fname) == true){
			return ReqFileType::TYPE_DIR;
		}
		return ReqFileType::TYPE_NOT_FOUND;
//			ErrorTools::ErrorExit(sprintf("%s : Line=%d : File extension is not support.(ext=$ext)",__FILE__,__LINE__) . ErrorTools::getStackStr(Pconst::NEW_LINE));
	}
}

//------------------------------------------------------------------
//	Class PepHitConst
//
//	PepHitViewで使用する定数を定義する。
//------------------------------------------------------------------
class PepHitConst{

// Get変数へのアクセスキー
	const GET_FILE = 'file';
	const GET_LINE_NO = 'lineNo';
	const GET_MASS_ERROR = 'massErr';
	const GET_MASS_ERROR_UNIT = 'massErrU';
	const GET_MS2_NUM = 'ms2Num';
	const GET_PRE_ERROR = 'preErr';
	const GET_PRE_ERROR_UNIT = 'preErrU';

	const PEP_HIT_VIEW = 'ProteoAnalysis/PepHitView.php';
	const PEP_HIT_VIEW_RB = 'ProteoAnalysis/PepHitView.rb';

}

?>

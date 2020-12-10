//
// Program.cs
//
// Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
//
// Released under the 3-clause BSD license.
// see https://opensource.org/licenses/bsd-3-clause
// or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
//

using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
//using System.Linq;
using System.Text;
//using System.Threading.Tasks;
using System.Diagnostics;

using Clearcore2.Data;
using Clearcore2.Data.AnalystDataProvider;
using Clearcore2.Data.DataAccess.SampleData;
using Clearcore2.RawXYProcessing;

namespace SearchMonoIsotope {

    class Program {
        static int Main(string[] args) {
            try {

                // 入力パラメータ数のチェック
                if (args.Length != 2 && args.Length != 6) {
                    Console.WriteLine("Version:" + SMIConst.VERSION + SMIConst.NEW_LINE);
                    throw new Exception("Parameter count mistake." + SMIConst.NEW_LINE +
                        "Usage : inWiffFile sampleNo peptideTol peptideTolUnit inCsvFile outCsvFile");
                }

                // ログ用のオブジェクトの作成
                TraceSource logObj = new TraceSource("TraceSourceApp");

                // wiffファイルアクセス用のライセンスの設定
                Clearcore2.Utility.Licensing.Protection.AppendLicenseKey(
                    @"<?xml version=""1.0"" encoding=""utf-8""?>
                        <license_key>
                            <company_name>***************************</company_name>
                            <product_name>***************************</product_name>
                            <features>***************************</features>
                            <key_data>***************************</key_data>
                        </license_key>"
                );


//                string inWiffFile = @"C:\Users\massUser\Documents\MassRawData\Applied\TestData\08_Ecoli_Light_HAMMOC_1.wiff";
//                string inWiffFile = @"C:\Users\massUser\Documents\MassRawData\Applied\TestData\25um-1ug-8h-try1-1.wiff";


                // 起動時のパラメータを取り出し
                String inWiffFile = args[0];
                Int32 sampleNo = Int32.Parse(args[1]);
                Double peptideTol = 0.0;
                String peptideTolUnit = "";
                String inCsvFile = "";
                String outCsvFile = "";

                if (args.Length == 6) {
                    peptideTol = Double.Parse(args[2]);
                    peptideTolUnit = args[3];
                    inCsvFile = args[4];
                    outCsvFile = args[5];
                }

                // 生データの存在チェック
                if (File.Exists(inWiffFile) == false) {
                    throw new Exception("File not found." + SMIConst.NEW_LINE + "fileName:" + inWiffFile);
                }

                // wiffファイルアクセス用オブジェクトの作成
                AnalystWiffDataProvider wiffProvider = new AnalystWiffDataProvider();
                Batch wiffBatchObj = AnalystDataProviderFactory.CreateBatch(inWiffFile, wiffProvider);

                // 入力パラメータが２だったらサンプル名を出力して終了する
                if (args.Length == 2) {
                    string[] sampleNameAry = wiffBatchObj.GetSampleNames();
                    Console.WriteLine("{0}", sampleNameAry[sampleNo]);
                    return 0;
                }


                // CSVファイルからプリカーサー値とcycleNoを取り出し
                CsvFileToArray csvToAryObj = new CsvFileToArray();
                csvToAryObj.setInFile(inCsvFile);
                csvToAryObj.exec();
                Hashtable csvData = csvToAryObj.getDataAry();
                List<Double> preMzAry = MyTools.convStrToDouble((List<String>)csvData["preInfo"]);
                List<Int32> cycleAry = MyTools.convStrToInt((List<String>)csvData["cycleInfo"]);
                csvToAryObj = null;




                // monoIsotopeをサーチする
                SearchMonoIso searchIsoObj = new SearchMonoIso();
                searchIsoObj.setSampleNo(sampleNo);
                searchIsoObj.setPeptideTol(peptideTol);
                searchIsoObj.setPeptideTolUnit(peptideTolUnit);
                searchIsoObj.setPreMzAry(preMzAry);
                searchIsoObj.setCycleAry(cycleAry);
                searchIsoObj.setBatchObj(wiffBatchObj);
                searchIsoObj.exec();


                // 結果のcsvDataを作成
                csvData = new Hashtable();
                csvData["monoIsoMz"] = MyTools.convDoubleToStr(searchIsoObj.getMonoIsoMz());
                csvData["monoIsoInt"] = MyTools.convIntToStr(searchIsoObj.getMonoIsoInt());
                csvData["monoIsoCharge"] = searchIsoObj.getMonoIsoCharge();
                csvData["isoCount"] = MyTools.convIntToStr(searchIsoObj.getIsoCount());
                csvData["isoError"] = MyTools.convBoolToStr(searchIsoObj.getIsoError());
                preMzAry = null;
                cycleAry = null;
                searchIsoObj = null;


                // csvDataからcsvファイルを作成
                ArrayToCsv aryToCsvObj = new ArrayToCsv();
                aryToCsvObj.setOutFile(outCsvFile);
                aryToCsvObj.setCsvTitle(MyTools.getHashKeys(csvData));
                aryToCsvObj.setDataAry(csvData);
                aryToCsvObj.exec();
                csvData = null;
                aryToCsvObj = null;


//                logObj.TraceEvent(TraceEventType.Error, 1, "Error");
//                logObj.TraceEvent(TraceEventType.Warning, 2, "File Test not found");
//                logObj.TraceEvent(TraceEventType.Error, 2, "Error");


                wiffBatchObj = null;
                wiffProvider.Close();
                logObj.Close();
            } catch (Exception e) {
                Console.WriteLine(e.ToString());
                return 1;
            }
            return 0;
        }
    }
}

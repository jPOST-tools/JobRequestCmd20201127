//
// Class1.cs
//
// Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
//
// Released under the 3-clause BSD license.
// see https://opensource.org/licenses/bsd-3-clause
// or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
//

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
//using System.Text;
//using System.Threading.Tasks;
using System.Diagnostics;
using Microsoft.VisualBasic.FileIO;

using Clearcore2.Data;
using Clearcore2.Data.AnalystDataProvider;
using Clearcore2.Data.DataAccess.SampleData;
using Clearcore2.RawXYProcessing;

namespace SearchMonoIsotope {
    class SMIConst {
        public const String NEW_LINE = "\r\n";
        public const String VERSION = "2013_11_25";
    }

    class MyTools {
        public static Double round(Double dValue, Int32 iDigits) {
            Double dCoef = System.Math.Pow(10, iDigits);
            Double rtc;
            if (dValue > 0) {
                rtc = System.Math.Floor((dValue * dCoef) + 0.5) / dCoef;
            } else {
                rtc = System.Math.Ceiling((dValue * dCoef) - 0.5) / dCoef;
            }
            return rtc;
        }


        public static List<Double> convStrToDouble(List<String> itemAry) {
            List<Double> rtcAry = new List<Double>();
            foreach (String wkStr in itemAry) {
                rtcAry.Add(Double.Parse(wkStr));
            }
            return rtcAry;
        }

        public static List<Int32> convStrToInt(List<String> itemAry) {
            List<Int32> rtcAry = new List<Int32>();
            foreach (String wkStr in itemAry) {
                rtcAry.Add(Int32.Parse(wkStr));
            }
            return rtcAry;
        }

        public static String[] convDoubleToStr(Double[] itemAry) {
            String[] rtcAry = new String[itemAry.Length];
            for (Int32 i = 0; i < itemAry.Length; i++) {
                rtcAry[i] = itemAry[i].ToString();
            }
            return rtcAry;
        }

        public static String[] convIntToStr(Int32[] itemAry) {
            String[] rtcAry = new String[itemAry.Length];
            for (Int32 i = 0; i < itemAry.Length; i++) {
                rtcAry[i] = itemAry[i].ToString();
            }
            return rtcAry;
        }

        public static String[] convBoolToStr(Boolean[] itemAry) {
            String[] rtcAry = new String[itemAry.Length];
            for (Int32 i = 0; i < itemAry.Length; i++) {
                rtcAry[i] = itemAry[i].ToString();
            }
            return rtcAry;
        }

        public static Int32[] convDoubleToInt(Double[] doubleAry) {
            Int32[] rtc = new Int32[doubleAry.Length];
            for (Int32 i = 0; i < doubleAry.Length; i++) {
                rtc[i] = (Int32)Math.Round(doubleAry[i], 0);

            }
            return rtc;
        }

        public static String[] getHashKeys(Hashtable itemAry) {
            String[] rtcAry = new String[itemAry.Count];
            Int32 i = 0;
            foreach (String keyWk in itemAry.Keys) {
                rtcAry[i] = keyWk;
                i++;
            }
            return rtcAry;
        }

        public static void debugPrint(String aTitle, Double[] aVal) {
            Console.WriteLine("{0}", aTitle);
            for (Int32 i = 0; i < aVal.Length; i++) {
                Console.WriteLine("{0}", aVal[i]);
            }
        }

        public static void debugPrint(String aTitle, Int32[] aVal) {
            Console.WriteLine("{0}", aTitle);
            for (Int32 i = 0; i < aVal.Length; i++) {
                Console.WriteLine("{0}", aVal[i]);
            }
        }

        public static void debugPrint(String aTitle, List<Double> aVal) {
            Console.WriteLine("{0}", aTitle);
            for (Int32 i = 0; i < aVal.Count; i++) {
                Console.WriteLine("{0}", aVal[i]);
            }
        }

        public static void debugPrint(String aTitle, List<Int32> aVal) {
            Console.WriteLine("{0}", aTitle);
            for (Int32 i = 0; i < aVal.Count; i++) {
                Console.WriteLine("{0}", aVal[i]);
            }
        }

    }

    class CsvFileToArray {
        private String inFile;
        private List<String> titleAry = new List<String>();
        private Hashtable dataAry = new Hashtable();

        public void setInFile(String aVal) {
            this.inFile = aVal;
        }

        public Hashtable getDataAry() {
            return this.dataAry;
        }

        public List<String> getTitleAry() {
            return this.titleAry;
        }

        private void check() {
            if (this.inFile == null) {
                throw new Exception("inFile is null.");
            }
        }

        public void exec() {
            this.check();

            TextFieldParser parser = new TextFieldParser(
                this.inFile, System.Text.Encoding.GetEncoding("utf-8"));

            using (parser) {
                parser.TextFieldType = FieldType.Delimited;
                parser.SetDelimiters("\t");

                int lineNo = 0;
                while (!parser.EndOfData) {
                    String[] itemsAry = parser.ReadFields(); // 1行読み込み

                    int itemNo = 0;
                    foreach (String fieldWk in itemsAry) {
                        if (lineNo == 0) {
                            this.titleAry.Add(fieldWk);
                            this.dataAry[fieldWk] = new List<String>();
                        } else {
                            List<String> wkAry = (List<String>)this.dataAry[titleAry[itemNo]];
                            wkAry.Add(fieldWk);
                        }
                        itemNo++;
                    }
                    lineNo++;
                }
            }
        }
    }

    class SearchMonoIso {
        private Int32 sampleNo = -1;
        private Double peptideTol = 0.0;
        private String peptideTolUnit;
        private List<Double> preMzAry;
        private List<Int32> cycleAry;
        private Batch batchObj;

        private Double[] monoIsoMz;
        private Int32[] monoIsoInt;
        private String[] monoIsoCharge;
        private Boolean[] isoError;
        private Int32[] isoCount;
 
        public void setSampleNo(Int32 aVal) {
            this.sampleNo = aVal;
       }

        public void setPeptideTol(Double aVal) {
            this.peptideTol = aVal;
        }

        public void setPeptideTolUnit(String aVal) {
            this.peptideTolUnit = aVal;
        }

        public void setPreMzAry(List<Double> aVal) {
            this.preMzAry = aVal;
        }

        public void setCycleAry(List<Int32> aVal) {
            this.cycleAry = aVal;
        }

        public void setBatchObj(Batch aVal) {
            this.batchObj = aVal;
        }

        public Double[] getMonoIsoMz() {
            return this.monoIsoMz;
        }

        public Int32[] getMonoIsoInt() {
            return this.monoIsoInt;
        }

        public String[] getMonoIsoCharge() {
            return this.monoIsoCharge;
        }

        public Int32[] getIsoCount() {
            return this.isoCount;
        }

        public Boolean[] getIsoError() {
            return this.isoError;
        }

        private void check() {
            if (this.sampleNo == -1) {
                throw new Exception("sampleNo is null.");
            }
            if (this.peptideTol == 0.0) {
                throw new Exception("peptideTol is null.");
            }
            if (this.peptideTolUnit == null) {
                throw new Exception("peptideTolUnit is null.");
            }
            if (this.preMzAry == null) {
                throw new Exception("preMzAry is null.");
            }
            if (this.cycleAry == null) {
                throw new Exception("cycleAry is null.");
            }
            if (this.batchObj == null) {
                throw new Exception("batchObj is null.");
            }
        }

        private Double getDiffVal(Double preMz, Double peptideTol, String peptideTolUnit) {
            if (peptideTolUnit == "Da") {
                return peptideTol;
            }
            return preMz * peptideTol / 1000000;
        }

        private void mzFilter(Double[] rdMzAry, Int32[] rdIntAry, Double lowMz, Double heighMz, ref List<Double> rtcMzAry, ref List<Int32> rtcIntAry){
            for (Int32 i = 0; i < rdMzAry.Length; i++) {
                if (rdMzAry[i] < lowMz) {
                    continue;
                }
                if (rdMzAry[i] > heighMz) {
                    break;
                }
                rtcMzAry.Add(rdMzAry[i]);
                rtcIntAry.Add(rdIntAry[i]);
            }
        }

        private void addPoint(List<Double> mzAry, List<Int32> intAry, Double oneMzVal, ref List<Double> addMzAry, ref List<Int32> addIntAry) {
            Double nextMz = 0.0;
            Int32 beforeInt = 0;
            Int32 emptyCount = 0;
            for (Int32 i = 0; i < mzAry.Count; i++) {
                Double nowMz = mzAry[i];
                Int32 nowInt = intAry[i];

                if (i <= 0) {
                    addMzAry.Add(nowMz);
                    addIntAry.Add(nowInt);
                    nextMz = nowMz + oneMzVal;
                    beforeInt = nowInt;
                    continue;
                }

                if (nowMz < nextMz) {
                    if (emptyCount <= 0) {
                        beforeInt = nowInt;
                    } else {
                        if (beforeInt < nowInt) {
                            beforeInt = nowInt;
                        }
                    }
                    emptyCount++;
                } else if (nowMz == nextMz) {
                    addMzAry.Add(nextMz);
                    if (beforeInt >= nowInt) {
                        addIntAry.Add(beforeInt);
                    } else {
                        addIntAry.Add(nowInt);
                    }
                    nextMz += oneMzVal;
                    beforeInt = nowInt;
                    emptyCount = 0;
                } else {
                    addMzAry.Add(nextMz);
                    addIntAry.Add(beforeInt);
                    nextMz += oneMzVal;
                    emptyCount = 0;
                    i--;
                }
            }
        }

        private void smoothing(List<Int32> intAry, Int32[][] nowSmoothConst, ref List<Int32> rtcSmIntAry) {
            Int32 intAryNum = intAry.Count;
            Int32 smoothNum = nowSmoothConst.Length;
            for (Int32 i = 0; i < intAryNum; i++) {
                Int32 sumVal = 0;
                for (Int32 j = 0; j < smoothNum; j++) {
                    Int32 smPt = nowSmoothConst[j][0];
                    Int32 weight = nowSmoothConst[j][1];
                    Int32 wkPt = i + smPt;
                    if (wkPt < 0 || intAryNum <= wkPt) {
                        sumVal = -1;
                        break;
                    }
                    sumVal += intAry[wkPt] * weight;
                }
                if (sumVal == -1) {
                    rtcSmIntAry.Add(intAry[i]);
                    continue;
                }
                rtcSmIntAry.Add(sumVal / smoothNum);
            }
        }

        private void peakPick(List<Double> mzAry, List<Int32> smIntAry, ref List<Double> rtcMzPeakAry, ref List<Int32> rtcIntPeakAry, ref List<Int32> rtcPeakIndexAry) {
            Int32 beforeInt = -1;
            Int32 beforeDiffInt = -1;
            Double beforeMz = 0.0;
            for (Int32 i = 0; i < mzAry.Count; i++) {
                Int32 nowInt = smIntAry[i];
                Double nowMz = mzAry[i];
                if (beforeInt == -1) {
                    beforeInt = nowInt;
                    beforeMz = nowMz;
                    continue;
                }
                Int32 diffInt = nowInt - beforeInt;
                if (beforeDiffInt == -1) {
                    beforeDiffInt = diffInt;
                    beforeInt = nowInt;
                    beforeMz = nowMz;
                    continue;
                }
                if (beforeDiffInt >= 0 && diffInt < 0) { // ピークの頂点が２点ある時に後ろ側を取るようにする。
 //               if (beforeDiffInt > 0 && diffInt <= 0) {
                    rtcMzPeakAry.Add(beforeMz);
                    rtcIntPeakAry.Add(beforeInt);
                    rtcPeakIndexAry.Add(i - 1);
                }
                beforeMz = nowMz;
                beforeInt = nowInt;
                beforeDiffInt = diffInt;
            }
        }

        private List<Int32> getTargetPeakInt(List<Int32> intPeakAry, Double ratioConst) {
            List<Int32> rtc = new List<Int32>();
            for (Int32 i = 0; i < intPeakAry.Count; i++) {
                rtc.Add((Int32)(intPeakAry[i] * ratioConst));
            }
            return rtc;
        }

        private List<Object> searchMzToPeakInt(List<Double> mzAry, List<Int32> smIntAry, List<Int32> targetIntAry, List<Int32> peakIndexAry) {
            Int32[] searchPeakAry = new Int32[] { -1, 1 };
            List<Object> waveChkMz = new List<Object>();
            for (Int32 i = 0; i < peakIndexAry.Count; i++) {
                Int32 peakPt = peakIndexAry[i];
                Int32 targetInt = targetIntAry[i];

                List<Double> rtcItem = new List<Double>();
                for (Int32 j = 0; j < searchPeakAry.Length; j++) {
                    Int32 beforeInt = -1;
                    Int32 beforeDiffInt = -1000000;
                    Double beforeMz = 0.0;
                    Int32 peakPtWk = peakPt;
                    Double mzWk = 0.0;
                    while (peakPtWk >= 0 && smIntAry.Count > peakPtWk) {
                        Int32 nowInt = smIntAry[peakPtWk];
                        Double nowMz = mzAry[peakPtWk];
                        if (beforeInt == -1) {
                            beforeInt = nowInt;
                            beforeMz = nowMz;
                            peakPtWk += searchPeakAry[j];
                            continue;
                        }

                        Int32 diffInt = nowInt - beforeInt;
                        if (beforeDiffInt == -1000000) {
                            beforeDiffInt = diffInt;
                        } else {
                            if (beforeDiffInt <= 0 && diffInt > 0) {
                                break;
                            }
                        }

                        if (nowInt > targetInt) {
                            beforeDiffInt = diffInt;
                            beforeInt = nowInt;
                            beforeMz = nowMz;
                            peakPtWk += searchPeakAry[j];
                            continue;
                        }

                        if ((beforeInt - nowInt) == 0) {
                            mzWk = beforeMz;
                        } else {
                            mzWk = (beforeMz - nowMz) / (beforeInt - nowInt);
                            mzWk *= (targetInt - nowInt);
                            mzWk += nowMz;
                        }
                        break;
                    }
                    if (mzWk > 0.0) {
                        rtcItem.Add(mzWk);
                    }
                }
                waveChkMz.Add(rtcItem);
            }
            return waveChkMz;
        }

        private List<Double> getPeakCenter(List<Object> waveChkMz, List<Double> addMzAry) {
            List<Double> rtc = new List<Double>();
            List<Object> centerAryWk = new List<Object>();
            Int32 itemCountBase = -1;
            for (Int32 i = 0; i < waveChkMz.Count; i++) {
                List<Object> waveNumAry = (List<Object>)waveChkMz[i];
                Int32 itemCount = waveNumAry.Count;
                if (itemCountBase == -1) {
                    itemCountBase = itemCount;
                } else {
                    if (itemCountBase != itemCount) {
                        continue;
                    }
                }
                for (Int32 j = 0; j < waveNumAry.Count; j++) {
                    if (i <= 0) {
                        centerAryWk.Add(new List<Double>());
                    }
                    List<Double> wkAry = (List<Double>)waveNumAry[j];
                    if (wkAry.Count != 2) {
                        continue;
                    }
                    Double peakLowMz = wkAry[0];
                    Double peakHighMz = wkAry[1];
                    wkAry = (List<Double>)centerAryWk[j];
                    wkAry.Add((peakHighMz - peakLowMz) / 2 + peakLowMz);
                }
            }

            for (Int32 i = 0; i < centerAryWk.Count; i++) {
                List<Double> wkAry = (List<Double>)centerAryWk[i];
                if (wkAry.Count <= 0) {
                    rtc.Add(addMzAry[i]);
                    continue;
                }
                Double sumWk = 0.0;
                for (Int32 j = 0; j < wkAry.Count; j++) {
                    sumWk += wkAry[j];
                }
                rtc.Add(sumWk / wkAry.Count);
            }
            return rtc;
        }

        private Int32 searchPrecursorPoint(List<Double> reMzPeakAry, Double preMz, Double diffVal) {
            Int32 rtc = -1;

            Double lowTargetMz = preMz - diffVal;
            Double heightTargetMz = preMz + diffVal;
            for (Int32 i = 0; i < reMzPeakAry.Count; i++) {
                Double nowMz = reMzPeakAry[i];
                if (nowMz < lowTargetMz) {
                    continue;
                }
                if (nowMz > heightTargetMz) {
                    break;
                }
                if (nowMz >= lowTargetMz && nowMz <= heightTargetMz) {
                    rtc = i;
                    break;
                }
            }
            return rtc;
        }

        private Double searchBestPrecursor(List<Double> reMzPeakAry, Double preMz) {
            Double beforeMz = 0.0;
            Double rtcPreMz = 0.0;
            for (Int32 i = 0; i < reMzPeakAry.Count; i++) {
                Double nowMz = reMzPeakAry[i];
                if (preMz < nowMz) {
                    Double beforeDiffVal = Math.Abs(beforeMz - preMz);
                    Double nowDiffVal = Math.Abs(nowMz - preMz);
                    if (beforeDiffVal <= nowDiffVal) {
                        rtcPreMz = beforeMz;
                    } else {
                        rtcPreMz = nowMz;
                    }
                    break;
                }
                beforeMz = nowMz;
                rtcPreMz = nowMz;
            }
            return rtcPreMz;
        }

        private void getMaxIntMz(
            List<Double> mzPeakAry, List<Int32> intPeakAry, Double lowMs2Mz, Double heighMs2Mz,
            ref Double tempMz, ref Int32 tempMzInt, ref Int32 tempMzPoint) {

            Int32 maxInt = -1;
            Int32 maxIntPoint = -1;
            Double maxIntMz  = 0.0;
            for (Int32 i = 0; i < mzPeakAry.Count; i++) {
                Double nowMz = mzPeakAry[i];
                Int32 nowInt = intPeakAry[i];
                if (nowMz < lowMs2Mz) {
                    continue;
                }
                if (nowMz > heighMs2Mz) {
                    break;
                }
                if (maxInt < 0) {
                    maxInt = nowInt;
                    maxIntPoint = i;
                    maxIntMz = nowMz;
                    continue;
                }
                if (nowInt <= maxInt) {
                    continue;
                }
                maxInt = nowInt;
                maxIntPoint = i;
                maxIntMz = nowMz;
            }
            if (maxInt < 0) {
                throw new Exception("maxInt is null.");
            }
            tempMz = maxIntMz;
            tempMzInt = maxInt;
            tempMzPoint = maxIntPoint;
        }

        private void searchMonoIso(Int32 shiftVal, Int32 startPoint, List<Double> reMzPeakAry,
        List<Int32> intPeakAry, Double preMz, Double diffVal, Double targetIsoDiff,
        Int32 searchLimit, Double intRatioLow, Double intRatioHeigh,
        ref Double calPreMzWk, ref Int32 calPreIntWk, ref Int32 calIsoCountWk, ref Int32 calIsoSumIntWk) {


            Int32 peakNum = startPoint;
            Int32 maxPeakNum = reMzPeakAry.Count;
            Int32 isoNum = 0;
            Int32 beforeInt = -1;
            Int32 beforeDiffInt = -1000000;

            while (peakNum >= 0 && peakNum < maxPeakNum) {
                Double targetMz = preMz + targetIsoDiff * isoNum;
                Double lowTargetMz = targetMz - diffVal;
                Double heightTargetMz = targetMz + diffVal;
                Double nowMz = reMzPeakAry[peakNum];
                Int32 nowInt = intPeakAry[peakNum];

                if (shiftVal < 0) {
                    if (heightTargetMz < nowMz) {
                        peakNum += shiftVal;
                        continue;
                    }
                    if (lowTargetMz > nowMz) {
                        break;
                    }
                } else {
                    if (lowTargetMz > nowMz) {
                        peakNum += shiftVal;
                        continue;
                    }
                    if (heightTargetMz < nowMz) {
                        break;
                    }
                }
                if (beforeInt < 0) {
                    calPreMzWk = nowMz;
                    calPreIntWk = nowInt;
                    beforeInt = nowInt;
                    calIsoSumIntWk += nowInt;
                    calIsoCountWk += 1;
                    peakNum += shiftVal;
                    isoNum += shiftVal;
                    continue;
                }

                if (calIsoCountWk > searchLimit) {
                    break;
                }

                Double expWk = (Double)nowInt / (Double)beforeInt;

                // データが有っても違いすぎたら同位体とみなさない
                if (expWk < intRatioLow || expWk > intRatioHeigh) {
                    break;
                }

                // 立ち上がりの変曲点を検知したら同位体ではない
                Int32 nowDiffInt = nowInt - beforeInt;
                if (beforeDiffInt == -1000000) {
                    beforeDiffInt = nowDiffInt;
                }else if (beforeDiffInt <= 0 && nowDiffInt > 0) {
                    break;
                }

                calPreMzWk = nowMz;
                calPreIntWk = nowInt;
                beforeInt = nowInt;
                calIsoSumIntWk += nowInt;
                beforeDiffInt = nowDiffInt;
                calIsoCountWk += 1;
                peakNum += shiftVal;
                isoNum += shiftVal;
            }
            if (calIsoCountWk <= 0) {
                throw new Exception("calIsoCountWk is null.");
            }
        }

        private Int32 selectBestCharge(List<Int32> calIsoCount, List<Int32> calIsoSumInt) {
            Int32 rtc = -1;
            Int32 beforeIsoCount = -1;
            Double beforeIsoSumInt = 0.0;
            for (Int32 i = 0; i < calIsoCount.Count; i++) {
                Int32 nowCount = calIsoCount[i];
                Double nowSumInt = calIsoSumInt[i];
                if (beforeIsoCount < 0) {
                    beforeIsoCount = nowCount;
                    beforeIsoSumInt = nowSumInt;
                    rtc = i;
                    continue;
                }
                if (beforeIsoCount > nowCount) {
                    continue;
                }
                if (beforeIsoCount == nowCount) {
                    if (beforeIsoSumInt >= nowSumInt) {
                        continue;
                    }
                }
                beforeIsoCount = nowCount;
                beforeIsoSumInt = nowSumInt;
                rtc = i;
            }
            return rtc;
        }

        private Double convMzToDalton(Double preMz, Int32 nowChg) {
            return preMz * nowChg - (nowChg * 1.00782503207) + (nowChg * 0.0005485799);
        }

        public void exec() {
            this.check();

            Double[] waveChkPt = { 0.8, 0.75 };
            Int32[] chargeChkAry = { 2, 3, 4, 5 };
            Double isoDiff = 1.00235;

            Hashtable smoothConst = new Hashtable();
            smoothConst["3"] = new Int32[][] {
                new Int32[] { -1, 1 },
                new Int32[] { 0, 1 },
                new Int32[] { 1, 1 },
            };
            smoothConst["5"] = new Int32[][] {
                new Int32[] { -2, 1 },
                new Int32[] { -1, 1 },
                new Int32[] { 0, 1 },
                new Int32[] { 1, 1 },
                new Int32[] { 2, 1 },
            };
            smoothConst["7"] = new Int32[][] {
                new Int32[] { -3, 1 },
                new Int32[] { -2, 1 },
                new Int32[] { -1, 1 },
                new Int32[] { 0, 1 },
                new Int32[] { 1, 1 },
                new Int32[] { 2, 1 },
                new Int32[] { 3, 1 },
            };

//            Int32[][] nowSmoothConst = (Int32[][])smoothConst["7"];
            Int32[][] nowSmoothConst = (Int32[][])smoothConst["5"];
//            Int32[][] nowSmoothConst = (Int32[][])smoothConst["3"];


            Sample sampleObj = this.batchObj.GetSample(this.sampleNo);
            MassSpectrometerSample msSampleObj = sampleObj.MassSpectrometerSample;
            MSExperiment expMsObj = msSampleObj.GetMSExperiment(0);

            Int32 polarityNum = 1; // positive
            if (expMsObj.Details.Polarity == MSExperimentInfo.PolarityEnum.Negative) {
                polarityNum = -1;
            }
            
            this.monoIsoMz = new Double[this.cycleAry.Count];
            this.monoIsoInt = new Int32[this.cycleAry.Count];
            this.monoIsoCharge = new String[this.cycleAry.Count];
            this.isoCount = new Int32[this.cycleAry.Count];
            this.isoError = new Boolean[this.cycleAry.Count];

            Console.WriteLine("Isotope search start: {0}", this.cycleAry.Count);

            for (Int32 i = 0; i < this.cycleAry.Count; i++) {

                if ((i + 1) % 1000 == 0) {
                    Console.WriteLine("Isotope search point: {0}", i+1);
                }

                Double preMz = this.preMzAry[i];
                Int32 cycleNo = this.cycleAry[i];

                Double diffVal = this.getDiffVal(preMz, this.peptideTol, this.peptideTolUnit);
                Double oneMzVal = diffVal * 0.6;    // diffVal内で必ず１ポイント入るようにする

                Double lowMz = 0.0;
                Double heighMz = 0.0;
                Double ms2Range = 0.5;
//                Double ms2PreModifyRatio = 5;
//                Double ms2PreModifyRatio = 3;

                if (preMz < 1000) {
                    lowMz = preMz - (isoDiff * 3) - diffVal;
                    heighMz = preMz + (isoDiff * 2) + diffVal;
                } else if (preMz < 2000) {
                    lowMz = preMz - (isoDiff * 4) - diffVal;
                    heighMz = preMz + (isoDiff * 3) + diffVal;
                } else if (preMz < 3000) {
                    lowMz = preMz - (isoDiff * 4) - diffVal;
                    heighMz = preMz + (isoDiff * 3) + diffVal;
                } else {
                    lowMz = preMz - (isoDiff * 5) - diffVal;
                    heighMz = preMz + (isoDiff * 4) + diffVal;
                }

                MassSpectrum specObj = expMsObj.GetMassSpectrum(cycleNo-1);
                Double[] rdMzAry = specObj.GetActualXValues();
                Int32[] rdIntAry = MyTools.convDoubleToInt(specObj.GetActualYValues());
//                MyTools.debugPrint("rdMzAry", rdMzAry);
//                MyTools.debugPrint("rdIntAry", rdIntAry);
//                throw new Exception("aaa");

                Int32 dataNum = rdMzAry.Length;

                List<Double> mzAry = new List<Double>();
                List<Int32> intAry = new List<Int32>();
                this.mzFilter(rdMzAry, rdIntAry, lowMz, heighMz, ref mzAry, ref intAry);
                rdMzAry = null;
                rdIntAry = null;
//                MyTools.debugPrint("mzAry", mzAry);
//                MyTools.debugPrint("intAry", intAry);
//                throw new Exception("aaa");

//                List<Double> addMzAry = new List<Double>();
//                List<Int32> addIntAry = new List<Int32>();
                List<Double> addMzAry = mzAry;
                List<Int32> addIntAry = intAry;
//                this.addPoint(mzAry, intAry, oneMzVal, ref addMzAry, ref addIntAry);
                mzAry = null;
                intAry = null;
//                MyTools.debugPrint("addMzAry", addMzAry);
//                MyTools.debugPrint("addIntAry", addIntAry);
//                throw new Exception("aaa");


                List<Int32> smIntAry = new List<Int32>();
                this.smoothing(addIntAry, nowSmoothConst, ref smIntAry);
//                smIntAry = addIntAry;
//                addIntAry = smIntAry;
//                smIntAry = new List<Int32>();
//                this.smoothing(addIntAry, nowSmoothConst, ref smIntAry);

                addIntAry = null;
//                MyTools.debugPrint("addMzAry", addMzAry);
//                MyTools.debugPrint("smIntAry", smIntAry);
//                throw new Exception("aaa");

                List<Double> mzPeakAry = new List<Double>();
                List<Int32> intPeakAry = new List<Int32>();
                List<Int32> peakIndexAry = new List<Int32>();
                this.peakPick(addMzAry, smIntAry, ref mzPeakAry, ref intPeakAry, ref peakIndexAry);
//                MyTools.debugPrint("mzPeakAry", mzPeakAry);
//                MyTools.debugPrint("intPeakAry", intPeakAry);
//                throw new Exception("aaa");


                List<Object> waveChkMz = new List<Object>();
                for (Int32 j = 0; j < waveChkPt.Length; j++) {
                    List<Int32> targetIntAry = this.getTargetPeakInt(intPeakAry, waveChkPt[j]);
                    waveChkMz.Add(new List<Object>());
                    waveChkMz[j] = this.searchMzToPeakInt(addMzAry, smIntAry, targetIntAry, peakIndexAry);
                }
//                throw new Exception("aaa");

                List<Double> reMzPeakAry = new List<Double>();
                reMzPeakAry = this.getPeakCenter(waveChkMz, mzPeakAry);
//                MyTools.debugPrint("reMzPeakAry", reMzPeakAry);
//                MyTools.debugPrint("reIntPeakAry", reIntPeakAry);
//                throw new Exception("aaa");


                // プリカーサーのM/Zが有るポイントを探す
                Int32 prePoint = this.searchPrecursorPoint(reMzPeakAry, preMz, diffVal);

                // プリカーサーが見つからなかったなら一番近いプリカーサーを見つける
                if (prePoint < 0) {
                    Double preMzWk = this.searchBestPrecursor(reMzPeakAry, preMz);
                    if (preMzWk != 0.0) {
                        preMz = preMzWk;
                        prePoint = this.searchPrecursorPoint(reMzPeakAry, preMz, diffVal);
                    }
                    this.isoError[i] = true;
                } else {
                    this.isoError[i] = false;
                }

/*              同定が増えても、その分減るのでやめる。
                // MS2を行う際イオンを導入する幅で大きいIntensityのM/Zがあったらそれをプリカーサーに補正する
                Int32 nowPreInt = intPeakAry[prePoint];
                Double lowMs2Mz = preMz - ms2Range;
                Double heighMs2Mz = preMz + ms2Range;
                Double tempMz = 0.0;
                Int32 tempMzInt = 0;
                Int32 tempMzPoint = 0;
                this.getMaxIntMz(reMzPeakAry, intPeakAry, lowMs2Mz, heighMs2Mz, ref tempMz, ref tempMzInt, ref tempMzPoint);

                if ((tempMzInt / nowPreInt) >= ms2PreModifyRatio) {
                    Console.WriteLine("PreIso change({0}) {1} {2} {3} {4}", i + 1, preMz, tempMz, nowPreInt, tempMzInt);
                    preMz = tempMz;
                    prePoint = tempMzPoint;
                }
*/


                List<Double> calPreMz = new List<Double>();
                List<Int32> calPreInt = new List<Int32>();
                List<Int32> calCharge = new List<Int32>();
                List<Int32> calIsoCount = new List<Int32>();
                List<Int32> calIsoSumInt = new List<Int32>();
                for (Int32 j = 0; j < chargeChkAry.Length; j++) {

                    Double calPreMzWk1 = 0.0;
                    Double calPreMzWk2 = 0.0;
                    Int32 calPreIntWk1 = 0;
                    Int32 calPreIntWk2 = 0;
                    Int32 calIsoCountWk1 = 0;
                    Int32 calIsoCountWk2 = 0;
                    Int32 calIsoSumIntWk1 = 0;
                    Int32 calIsoSumIntWk2 = 0;


                    // プリカーサーが見つかっていない場合はMonoIsoを探さない
                    if (prePoint < 0) {
                        break;
                    }

                    Int32 nowChg = chargeChkAry[j];
                    Double targetIsoDiff = isoDiff / nowChg;
                    calCharge.Add(nowChg);

                    // ターゲットの分子量の計算
                    Double preDalton = this.convMzToDalton(preMz, nowChg);

                    Int32 searchLimit1 = 0;
                    Int32 searchLimit2 = 0;
                    Double intRatioLow1 = 0.0;
                    Double intRatioHeigh1 = 0.0;
                    Double intRatioLow2 = 0.0;
                    Double intRatioHeigh2 = 0.0;
                    if (preDalton <= 1600) {
                        searchLimit1 = 0;
                        searchLimit2 = 4;
//                        searchLimit1 = 1;
//                        intRatioLow1 = 0.7;
//                        intRatioHeigh1 = 1.2;
                        intRatioLow1 = 0.0;
                        intRatioHeigh1 = 0.0;
                        intRatioLow2 = 0.3;
                        intRatioHeigh2 = 1.2;
                    } else if (preDalton <= 4500) {
                        searchLimit1 = 1;
                        searchLimit2 = 8;
                        intRatioLow1 = 0.3;
//                        intRatioHeigh1 = 1.2;
                        intRatioHeigh1 = 2.1;
                        intRatioLow2 = 0.3;
                        intRatioHeigh2 = 1.2;
                    } else if (preDalton <= 6400) {
                        searchLimit1 = 2;
                        searchLimit2 = 10;
                        intRatioLow1 = 0.2;
//                        intRatioHeigh1 = 1.2;
                        intRatioHeigh1 = 1.7;
                        intRatioLow2 = 0.3;
                        intRatioHeigh2 = 1.2;
                    } else {
                        searchLimit1 = 3;
                        searchLimit2 = 10;
                        intRatioLow1 = 0.2;
                        intRatioHeigh1 = 1.2;
                        intRatioLow2 = 0.3;
                        intRatioHeigh2 = 1.2;
                    }

                    // プリカーサーの左側のサーチ
                    this.searchMonoIso(-1, prePoint, reMzPeakAry, intPeakAry, preMz, diffVal, targetIsoDiff,
                        searchLimit1, intRatioLow1, intRatioHeigh1,
                        ref calPreMzWk1, ref calPreIntWk1, ref calIsoCountWk1, ref calIsoSumIntWk1);

                    calPreMz.Add(calPreMzWk1);
                    calPreInt.Add(calPreIntWk1);

                    // プリカーサーの右側のサーチ
                    this.searchMonoIso(1, prePoint, reMzPeakAry, intPeakAry, preMz, diffVal, targetIsoDiff,
                        searchLimit2, intRatioLow2, intRatioHeigh2,
                        ref calPreMzWk2, ref calPreIntWk2, ref calIsoCountWk2, ref calIsoSumIntWk2);

                    calIsoCount.Add(calIsoCountWk1 + calIsoCountWk2 - 1); // プリカーサーのM/Zは２回カウントしているので-1する
                    calIsoSumInt.Add(calIsoSumIntWk1 + calIsoSumIntWk2); // プリカーサーのIntensityは２回Sumしている
                }


//                if (i == 21135) {
//                    MyTools.debugPrint("calPreMz", calPreMz);
//                    MyTools.debugPrint("reMzPeakAry", reMzPeakAry);
//                }

                if (prePoint < 0) {
                    this.monoIsoMz[i] = preMz;
                    this.monoIsoInt[i] = 0;
                    this.monoIsoCharge[i] = "0";
                    this.isoCount[i] = 0;
//                    this.isoError[i] = true;
                } else {
                    Int32 bestPoint = this.selectBestCharge(calIsoCount, calIsoSumInt);
                    this.monoIsoMz[i] = calPreMz[bestPoint];
                    this.monoIsoInt[i] = calPreInt[bestPoint];
                    this.monoIsoCharge[i] = (calCharge[bestPoint] * polarityNum).ToString();
                    this.isoCount[i] = calIsoCount[bestPoint];
//                    this.isoError[i] = false;

//                    if (i == 21135) {
//                        Console.WriteLine("bestPoint: {0}, calPreMz: {1}", bestPoint, calPreMz[bestPoint]);
//                    }
                }

//                if (i == 21135) {
//                    Double aa = preMz;
//                    Console.WriteLine("preMz: {0}, monoIsoMz: {1}", preMz, this.monoIsoMz[i]);
//                }
            }
            Console.WriteLine("Isotope search point: {0}", this.cycleAry.Count);
        }
    }

    class ArrayToCsv {
        private String outFile;
        private String[] csvTitle;
        private Hashtable dataAry;

        public void setOutFile(String aVal) {
            this.outFile = aVal;
        }

        public void setCsvTitle(String[] aVal) {
            this.csvTitle = aVal;
        }

        public void setDataAry(Hashtable aVal) {
            this.dataAry = aVal;
        }

        private void check() {
            if (this.outFile == null) {
                throw new Exception("outFile is null.");
            }
            if (this.csvTitle == null) {
                throw new Exception("csvTitle is null.");
            }
            if (this.dataAry == null) {
                throw new Exception("dataAry is null.");
            }
        }

        private Boolean needDoubleQuotes(String aVal) {
            if (
                aVal.IndexOf('"') > -1 ||
                aVal.IndexOf(',') > -1 ||
                aVal.IndexOf('\r') > -1 ||
                aVal.IndexOf('\n') > -1 ||
                aVal.StartsWith(" ") ||
                aVal.StartsWith("\t") ||
                aVal.EndsWith(" ") ||
                aVal.EndsWith("\t")) {

                return true;
            }
            return false;
        }

        private String convDoubleQuotesString(String aVal) {
            if (aVal.IndexOf('"') > -1) {
                aVal = aVal.Replace("\"", "\"\"");
            }
            return "\"" + aVal + "\"";
        }

        private String getConvString(String aVal) {
            if (this.needDoubleQuotes(aVal) == true) {
                this.convDoubleQuotesString(aVal);
            }
            return aVal;
        }

        public void exec() {
            this.check();

            String sepStr = "\t";
            String newLine = "\r\n";

//            System.Text.Encoding enc = System.Text.Encoding.GetEncoding("utf-8");
            System.Text.Encoding enc = System.Text.Encoding.GetEncoding("us-ascii");

            System.IO.StreamWriter fp = new System.IO.StreamWriter(this.outFile, false, enc);
            using (fp) {
                for (Int32 i = 0; i < csvTitle.Length; i++) {
                    if (i > 0) {
                        fp.Write(sepStr);
                    }
                    String wkStr = this.getConvString(csvTitle[i]);
                    fp.Write(wkStr);
                }
                fp.Write(newLine);

                String[] wkItem = (String[])dataAry[csvTitle[0]];
                Int32 dataNum = wkItem.Length;

                for (Int32 i = 0; i < dataNum; i++) {
                    for (Int32 j = 0; j < csvTitle.Length; j++) {
                        if (j > 0) {
                            fp.Write(sepStr);
                        }
                        wkItem = (String[])dataAry[csvTitle[j]];
                        String wkStr = this.getConvString(wkItem[i]);
                        fp.Write(wkStr);
                    }
                    fp.Write(newLine);
                }
            }
        }
    }
}

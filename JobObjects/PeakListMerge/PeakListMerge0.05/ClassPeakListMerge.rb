# encoding: utf-8
#
# ClassPeakListMerge.rb
#
# Copyright © 2020 Tsuyoshi Tabata for jPOST  All rights reserved.
#
# Released under the 3-clause BSD license.
# see https://opensource.org/licenses/bsd-3-clause
# or https://github.com/jPOST-tools/JobRequestCmd20201127/blob/main/LICENSE
#

=begin
-----------------------------------------------------------------------------
	PLmergeTools

	PeakListMergeで使用する関数群を定義する。
-----------------------------------------------------------------------------
=end

class PLmergeTools
	def PLmergeTools.debugPrintScanChgUniq(aScanChgUniq)
		puts "aRawFilebase\taScanNoWk\tpreChgWk\taRtimeStr\tpreValWk\tpreIntWk\taPlistProg\taLastEqPos\taFp"
		aScanChgUniq.each{|aAry|
			aAry.each{|aItemAry|
				(aScanNoWk,aRtimeStr,preValWk,preIntWk,preChgWk,aLastEqPos,aFp,aPlistProg,aRawFilebase) = aItemAry
				puts "#{aRawFilebase}\t#{aScanNoWk}\t#{preChgWk}\t#{aRtimeStr}\t#{preValWk}\t#{preIntWk}\t#{aPlistProg}\t#{aLastEqPos}\t#{aFp}"
			}
		}
	end

	def PLmergeTools.getDiffVal(aPreMz,aPeptideTol,aPeptideTolUnit)
		if(aPeptideTolUnit == PeakListMerge::PLM_TOL_U_DA)
			return aPeptideTol
		end
		return aPreMz * aPeptideTol / 1000000
	end

end

=begin
-----------------------------------------------------------------------------
	GroupPreVal

	同一生データの同一ScanNo+chargeで複数プリカーサー値をグループ化
	する。
-----------------------------------------------------------------------------
=end

class GroupPreVal
	def initialize()
	end

	def setPeakFile(aVal)
		@peakFile = aVal
	end

	def setScanChgUniq(aVal)
		@scanChgUniq = aVal
	end

	def setRawFilePath(aVal)
		@rawFilePath = aVal
	end

	def check()
		if(@peakFile.nil? == true)
			MyTools.printfAndExit(1,"@peakFile is nill.",caller(0))
		end
		if(@scanChgUniq.nil? == true)
			MyTools.printfAndExit(1,"@scanChgUniq is nill.",caller(0))
		end
		if(@rawFilePath.nil? == true)
			MyTools.printfAndExit(1,"@rawFilePath is nill.",caller(0))
		end
	end

	def getItemVal(aSep,aStr,aLineNo)
		(keyStr,valStr) = aStr.split(aSep,2)
		if(valStr == nil)
			p aStr
			MyTools.printfAndExit(1,"itemStr is mistake.(lineNo:#{aLineNo})",caller(0))
		end
		return [keyStr,valStr]
	end

	def getPreAndIntChgVal(aStr)
		(keyStr,valStr,chgStr) = aStr.split(' ',3)
		if(valStr == nil)
			valStr = ''
		end
		if(chgStr == nil)
			chgStr = ''
		end
		return [keyStr,valStr,chgStr]
	end

	def getKeyVal(aSplitStr,aTitleStr)
		wkAry = aTitleStr.split(aSplitStr,2)
		if(wkAry.length < 2)
			p aTitleStr
			MyTools.printfAndExit(1,"CometStr is mistake.",caller(0))
		end
		wkAry = wkAry[1].split(', ',2)
		if(wkAry.length < 2)
			p aTitleStr
			MyTools.printfAndExit(1,"CometStr is mistake.",caller(0))
		end
		return wkAry[0]
	end

	def nilCheck(aChkAry)
		aChkAry.each{|aVal|
			if(aVal == nil)
				p aChkAry
				MyTools.printfAndExit(1,"peakList item is mistake.",caller(0))
			end
		}
	end

	def setResultAry(aRawFilebase,aScanNoWk,aRtimeStr,aChgValStr,aLastEqPos,aFp,aPreValAry,aPreIntAry,aPreChgAry,aPlistProg,aScanChgUniq)
		aPreValAry.each_index{|i|
			preValWk = aPreValAry[i]
			preIntWk = aPreIntAry[i]
			preChgWk = aPreChgAry[i]

			if(preChgWk == '')
				preChgWk = aChgValStr
			end

			if(preChgWk == '')
				keyStr = "#{aScanNoWk} 0"
			else
				keyStr = "#{aScanNoWk} #{preChgWk[0]}"
			end

			if(aScanChgUniq[aRawFilebase] == nil)
				aScanChgUniq[aRawFilebase] = {}
			end

			rawFileAry = aScanChgUniq[aRawFilebase]

			if(rawFileAry[keyStr] == nil)
				rawFileAry[keyStr] = []
			end

			rawFileAry[keyStr].push([aScanNoWk,aRtimeStr,preValWk,preIntWk,preChgWk,aLastEqPos,aFp,aPlistProg,aRawFilebase])
		}
	end

	def getPlistProg(aFileBase)
		wkAry = aFileBase.split('.')
		if(wkAry.length < 3)
			return ''
		end
		return wkAry[wkAry.length - 2]
	end

	def exec()
		self.check()

		lineNo = 0
		firstBigin = nil
		scanNoWk = nil
		rtimeStr = nil
		preValAry= []
		preIntAry = []
		preChgAry = []
		chgValStr = ''
		lastEqPos = nil
		rawFilebase = nil

		plistProg = self.getPlistProg(File.basename(@peakFile))
#p plistProg
#exit(0)

		fp = File.open(@peakFile,File::RDONLY)
#p @inFile
#exit(0)
		while lineStr = fp.gets()
			lineNo += 1
			lineStr = lineStr.rstrip()

			if(lineStr == '')
				next
			end

			if(lineStr == 'BEGIN IONS')
				firstBigin = true
				next
			end

			if(firstBigin == nil)
				next
			end

			if(lineStr == 'END IONS')
				self.nilCheck([scanNoWk,rtimeStr,chgValStr,lastEqPos,rawFilebase])
				if(preValAry.length <= 0)
					p [scanNoWk,rtimeStr,chgValStr,lastEqPos,rawFilebase]
					MyTools.printfAndExit(1,"preValAry is nill.",caller(0))
				end

				self.setResultAry(rawFilebase,scanNoWk,rtimeStr,chgValStr,lastEqPos,fp,preValAry,preIntAry,preChgAry,plistProg,@scanChgUniq)

#p @scanChgUniq
#exit(0)


				scanNoWk = nil
				rtimeStr = nil
				preValAry = []
				preIntAry = []
				preChgAry = []
				chgValStr = ''
				lastEqPos = nil
				rawFilebase = nil
			end

			if(lineStr.index('=') != nil)
				lastEqPos = fp.pos
			end

			if(lineStr.index('TITLE=') != nil)
				scanNoWk = self.getKeyVal('spec_id: ',lineStr)
				rawFilePath = self.getKeyVal('file_path: ',lineStr)
				rawFilebase = File.basename(rawFilePath)
				if(@rawFilePath[rawFilebase] == nil)
					@rawFilePath[rawFilebase] = rawFilePath
				end
#p rawFilebase
#p @rawFilePath
#exit(0)
				next
			end

			if(lineStr.index('RTINSECONDS=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				rtimeStr = wkVal
				next
			end
			if(lineStr.index('PEPMASS=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				(preWk,preInt,chgVal) = self.getPreAndIntChgVal(wkVal)
				preValAry.push(preWk)
				preIntAry.push(preInt)
				preChgAry.push(chgVal)
				next
			end
			if(lineStr.index('CHARGE=') != nil)
				(noUse,wkVal) = self.getItemVal('=',lineStr,lineNo)
				chgValStr = wkVal
				next
			end

		end

		return fp
	end
end

=begin
-----------------------------------------------------------------------------
	DeleteSamePrecorsor

	トレランスの範囲内に入っているプリカーサーを削除する。
-----------------------------------------------------------------------------
=end

class DeleteSamePrecorsor
	def initialize()
	end

	def setScanChgUniq(aVal)
		@scanChgUniq = aVal
	end

	def setPepTol(aVal)
		@pepTol = aVal
	end

	def setPepTolU(aVal)
		@pepTolU = aVal
	end

	def check()
		if(@scanChgUniq.nil? == true)
			MyTools.printfAndExit(1,"@scanChgUniq is nill.",caller(0))
		end
		if(@pepTol.nil? == true)
			MyTools.printfAndExit(1,"@pepTol is nill.",caller(0))
		end
		if(@pepTolU.nil? == true)
			MyTools.printfAndExit(1,"@pepTolU is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		rtcScanChgUnique = []
		rtcFpHash = []
		allPreGrNum = 0
		sumPreGrNum = 0
		deletePreNum = 0
		scanNoBefore = nil
		rtcPreGrAry = []
		fpAry = {}

		@scanChgUniq.each{|aPreGrAry|
			preValHigh = nil
			plistProgAry = {}
			saveItemAry = nil
			sumPreGrNum += aPreGrAry.length

			aPreGrAry.each{|aItemAry|
				(aScanNoWk,aRtimeStr,preValWk,preIntWk,preChgWk,aLastEqPos,aFp,aPlistProg,aRawFilebase) = aItemAry

				if(scanNoBefore == nil)
					scanNoBefore = aScanNoWk
				end

				if(scanNoBefore != aScanNoWk)
					rtcScanChgUnique.push(rtcPreGrAry)
					rtcFpHash.push(fpAry)
#p rtcScanChgUnique
#p rtcFpHash
#p rtcPreGrAry
#p fpAry
#p scanNoBefore
#p aScanNoWk
#exit(0)
					rtcPreGrAry = []
					fpAry = {}
					scanNoBefore = aScanNoWk

				end

				preVal = preValWk.to_f()
				dlffval = PLmergeTools.getDiffVal(preVal,@pepTol,@pepTolU)
				fpAry[aFp] = [aLastEqPos,aPlistProg]

				if(preValHigh == nil)
					saveItemAry = aItemAry
					plistProgAry[aPlistProg] = true
					preValHigh = preVal + dlffval
					next
				end


				if(preVal <= preValHigh)
					plistProgAry[aPlistProg] = true
					deletePreNum += 1
					next
				end

				saveItemAry[7] = plistProgAry
				rtcPreGrAry.push(saveItemAry)
				plistProgAry = {}
				allPreGrNum += 1

				saveItemAry = aItemAry
				plistProgAry[aPlistProg] = true
				preValHigh = preVal + dlffval
#p preValHigh
#p preVal
#exit(0)

			}
			saveItemAry[7] = plistProgAry
			rtcPreGrAry.push(saveItemAry)
			allPreGrNum += 1

#p saveItemAry
#p deletePreNum
#p allPreGrNum
#p plistProgAry
#p rtcPreGrAry
#p rtcScanChgUnique
#p rtcFpHash
#exit(0)
		}
		if(rtcPreGrAry.length > 0)
			rtcScanChgUnique.push(rtcPreGrAry)
			rtcFpHash.push(fpAry)
		end

		puts "allPreGrNum:#{allPreGrNum} deletePreNum:#{deletePreNum} sumPreGrNum:#{sumPreGrNum}"

		return [rtcScanChgUnique,rtcFpHash]
	end
end

=begin
-----------------------------------------------------------------------------
	Ms2MaegeAndPeaklist

	MS2のピークは、どのソフトで作ったものが良いかを選びながら
	入力のプリカーサー値を使い、Peaklistを作成する。
-----------------------------------------------------------------------------
=end

class Ms2MaegeAndPeaklist
	def initialize()
	end

	def setScanChgUniq(aVal)
		@scanChgUniq = aVal
	end

	def setScanChgFp(aVal)
		@scanChgFp = aVal
	end

	def setRawFilePath(aVal)
		@rawFilePath = aVal
	end

	def setMultiPre(aVal)
		@multiPre = aVal
	end

	def setMs2Select(aVal)
		@ms2Select = aVal
	end

	def setMs2minInt(aVal)
		@ms2minInt = aVal
	end

	def setOutFile(aVal)
		@outFile = aVal
	end

	def check()
		if(@scanChgUniq.nil? == true)
			MyTools.printfAndExit(1,"@scanChgUniq is nill.",caller(0))
		end
		if(@scanChgFp.nil? == true)
			MyTools.printfAndExit(1,"@scanChgFp is nill.",caller(0))
		end
		if(@rawFilePath.nil? == true)
			MyTools.printfAndExit(1,"@rawFilePath is nill.",caller(0))
		end
		if(@multiPre.nil? == true)
			MyTools.printfAndExit(1,"@multiPre is nill.",caller(0))
		end
		if(@ms2Select.nil? == true)
			MyTools.printfAndExit(1,"@ms2Select is nill.",caller(0))
		end
		if(@ms2minInt.nil? == true)
			MyTools.printfAndExit(1,"@ms2minInt is nill.",caller(0))
		end
		if(@outFile.nil? == true)
			MyTools.printfAndExit(1,"@outFile is nill.",caller(0))
		end
	end

	def getMsRawType(aPreGrAry)
		(aScanNoWk,aRtimeStr,preValWk,preIntWk,preChgWk,aLastEqPos,aFp,aPlistProg,aRawFilebase) = aPreGrAry[0]
		if(aRawFilebase.downcase.index(".#{PeakListMerge::PLM_MS_TYPE_AB}") != nil)
			return PeakListMerge::PLM_MS_TYPE_AB
		elsif(aRawFilebase.downcase.index(".#{PeakListMerge::PLM_MS_TYPE_THERMO}") != nil)
			return PeakListMerge::PLM_MS_TYPE_THERMO
		end
		p aRawFilebase
		MyTools.printfAndExit(1,"getMsRawType is mistake.",caller(0))
	end

	def selectMs2File(aFpAry,aMs2PeakScore)
		sortAryTemp = []
		aFpAry.each{|aFp,aItemAry|
			(lastEqPos,plistProg) = aItemAry
			if(aMs2PeakScore[plistProg] == nil)
				p plistProg
				MyTools.printfAndExit(1,"plistProg is mistake.",caller(0))
			end
			sortAryTemp.push([aMs2PeakScore[plistProg],aFp,lastEqPos])
		}
#p sortAryTemp
		sortedAry = sortAryTemp.sort{|a,b|
			b[0] <=> a[0]
		}
#p sortedAry
		(peakListScore,fp,lastEqPos) = sortedAry[0]
		return [fp,lastEqPos]
	end

	def getMs2Peak(aRfp,aLastEqPos,aMs2minInt,aNewLine)
		rtc = []
		aRfp.seek(aLastEqPos)
		while lineStr = aRfp.gets()
			lineStr = lineStr.rstrip()
			if(lineStr == 'END IONS')
				break
			end
			wkAry = lineStr.split(/\t| /)
			if(wkAry.length != 2)
				p lineStr,aFp
				MyTools.printfAndExit(1,"lineStr is mistake.",caller(0))
			end
			nowInt = wkAry[1].to_f()
			if(nowInt < aMs2minInt)
				next
			end
			rtc.push("#{wkAry[0]} #{wkAry[1]}")
		end
		return rtc.join(aNewLine)
	end

	def getPreStr(aPreGrAry,aPreRound,aNewLine)
		rtcPreStr = ''
		rtcPlistProgAry = {}
		scanNo = nil
		preChgTop = nil
		rtimeValTop = nil
		rawFilebase = nil
		aPreGrAry.each{|aItemAry|
			(scanNo,rtimeVal,preVal,preInt,preChg,lastEqPos,rfp,plistProgAry,rawFilebase) = aItemAry
			preValStr = sprintf("%#.#{aPreRound}f",preVal.to_f().round(aPreRound))

			if(preInt == '')
				preInt = '0.0'
			end
			if(preChg == "")
				rtcPreStr += "PEPMASS=#{preValStr} #{preInt}#{aNewLine}"
			else
				rtcPreStr += "PEPMASS=#{preValStr} #{preInt} #{preChg}#{aNewLine}"
			end
			if(preChgTop == nil)
				preChgTop = preChg
				rtimeValTop = rtimeVal
			end
			rtcPlistProgAry = rtcPlistProgAry.merge(plistProgAry)
		}
		return [rtcPreStr,scanNo,preChgTop,rtimeValTop,rawFilebase,rtcPlistProgAry]
	end

	def getTitleStr(aMsRawType,aScanNo,aRtimeStr,aPreValStr,aPreChg,aRawFilebase,aPlistProgAry,aRawFilePath)
		rtcAry = []
		wkAry = aPlistProgAry.keys()
		plistStr = wkAry.join('/')

		# ABsciexの場合
		if(aMsRawType == PeakListMerge::PLM_MS_TYPE_AB)
			wkAry = aScanNo.split('.')
			if(wkAry.length != 4)
				p laScanNo
				MyTools.printfAndExit(1,"scanNo is mistake.",caller(0))
			end
			if(aRawFilePath[aRawFilebase] == nil)
				p aRawFilePath,aRawFilebase
				MyTools.printfAndExit(1,"scanNo is mistake.",caller(0))
			end
			aPlistProgAry.keys()
			rtcAry.push("spec_id: #{aScanNo}")
			rtcAry.push("sample: #{wkAry[0]}")
			rtcAry.push("period: #{wkAry[1]}")
			rtcAry.push("cycle: #{wkAry[2]}")
			rtcAry.push("experiment: #{wkAry[3]}")
			rtcAry.push("file_path: #{aRawFilePath[aRawFilebase]}")
			rtcAry.push("spec_rt: #{aRtimeStr}")
			if(aPreValStr != '')
				rtcAry.push("spec_prec: #{aPreValStr}")
			end
			rtcAry.push("spec_stage: 2")
			if(aPreChg != '')
				rtcAry.push("charge: #{aPreChg[0]}")
			end
			rtcAry.push("PLmerge: #{plistStr}")
			rtcAry.push(" File: #{aRawFilebase}")

			return rtcAry.join(', ')
		end

		# Thermo-Rawの場合
		rtcAry.push("spec_id: #{aScanNo}")
		rtcAry.push("sample_index: 0")
		rtcAry.push("sample_name: MS")
		rtcAry.push("file_path: #{aRawFilePath[aRawFilebase]}")
		rtcAry.push("spec_rt: #{aRtimeStr}")
		if(aPreValStr != '')
			rtcAry.push("spec_prec: #{aPreValStr}")
		end
		rtcAry.push("spec_stage: 2")
		if(aPreChg != '')
			rtcAry.push("charge: #{aPreChg[0]}")
		end
		rtcAry.push("polarity:  1 - Scan#{aScanNo}")
		rtcAry.push("PLmerge: #{plistStr}")
		rtcAry.push(" File: #{aRawFilebase}")
		return rtcAry.join(', ')
	end

	def exec()
		self.check()

		newLine = "\r\n"
		rtimeRound = 6
		preRound = 5

		ms2PeakScore = {
			"#{PeakListMerge::PLM_MS_TYPE_AB}:#{PeakListMerge::PLM_MS2_SELECT_PILOT}" => {
				'pilotFin' => 6,
				'pilot' => 5,
				'mscon' => 4,
				'wizd' => 3,
				'maxq' => 2,
				'maxqFin' => 1,
				'dsco' => 0,
			},
			"#{PeakListMerge::PLM_MS_TYPE_AB}:#{PeakListMerge::PLM_MS2_SELECT_MSCON}" => {
				'pilotFin' => 5,
				'pilot' => 4,
				'mscon' => 6,
				'wizd' => 3,
				'maxq' => 2,
				'maxqFin' => 1,
				'dsco' => 0,
			},
			"#{PeakListMerge::PLM_MS_TYPE_AB}:#{PeakListMerge::PLM_MS2_SELECT_WIZD}" => {
				'pilotFin' => 3,
				'pilot' => 2,
				'mscon' => 1,
				'wizd' => 6,
				'maxq' => 5,
				'maxqFin' => 4,
				'dsco' => 0,
			},
			"#{PeakListMerge::PLM_MS_TYPE_THERMO}:#{PeakListMerge::PLM_MS2_SELECT_MAXQ}" => {
				'pilotFin' => 0,
				'pilot' => 1,
				'mscon' => 2,
				'wizd' => 3,
				'maxq' => 6,
				'maxqFin' => 5,
				'dsco' => 4,
			},
			"#{PeakListMerge::PLM_MS_TYPE_THERMO}:#{PeakListMerge::PLM_MS2_SELECT_WIZD}" => {
				'pilotFin' => 0,
				'pilot' => 1,
				'mscon' => 2,
				'wizd' => 6,
				'maxq' => 5,
				'maxqFin' => 4,
				'dsco' => 3,
			},
			"#{PeakListMerge::PLM_MS_TYPE_THERMO}:#{PeakListMerge::PLM_MS2_SELECT_WIZD}" => {
				'pilotFin' => 0,
				'pilot' => 1,
				'mscon' => 2,
				'wizd' => 6,
				'maxq' => 5,
				'maxqFin' => 4,
				'dsco' => 3,
			},
			"#{PeakListMerge::PLM_MS_TYPE_THERMO}:#{PeakListMerge::PLM_MS2_SELECT_DSCO}" => {
				'pilotFin' => 0,
				'pilot' => 1,
				'mscon' => 2,
				'wizd' => 5,
				'maxq' => 4,
				'maxqFin' => 3,
				'dsco' => 6,
			},
		}

		plistStr = "SEARCH=MIS#{newLine}"
		plistStr += "REPTYPE=Peptide#{newLine}"

		wfp = File.open(@outFile,"wb+")
		wfp.write(plistStr)


		@scanChgUniq.each_index{|i|
			preGrAry = @scanChgUniq[i]
			fpAry = @scanChgFp[i]

			msRawType = self.getMsRawType(preGrAry)
#p msRawType
#p preGrAry
#exit(0)
			ms2SelectKey = "#{msRawType}:#{@ms2Select}"

			if(ms2PeakScore[ms2SelectKey] == nil)
				p ms2SelectKey
				MyTools.printfAndExit(1,"ms2SelectKey is nill.",caller(0))
			end

			(rfp,lastEqPos) = self.selectMs2File(fpAry,ms2PeakScore[ms2SelectKey])
#p rfp,lastEqPos
#exit(0)

			ms2Str = self.getMs2Peak(rfp,lastEqPos,@ms2minInt,newLine)
			if(ms2Str == '')
#				p preGrAry
#				MyTools.printfAndExit(1,"ms2Str is nill.",caller(0))
				next
			end
#p ms2Str
#exit(0)

			# @multiPre = trueの場合のピークリスト
			if(@multiPre == true)
				(preStr,scanNo,preChg,rtimeVal,rawFilebase,plistProgAry) = self.getPreStr(preGrAry,preRound,newLine)
				rtimeStr = sprintf("%#.#{rtimeRound}f",rtimeVal.to_f().round(rtimeRound) / 60)
				titleStr = self.getTitleStr(msRawType,scanNo,rtimeStr,'','',rawFilebase,plistProgAry,@rawFilePath)


				plistStr = newLine
				plistStr += "BEGIN IONS#{newLine}"
				plistStr += "#{preStr}"
				if(preChg != '')
					plistStr += "CHARGE=#{preChg}#{newLine}"
				end
				plistStr += "TITLE=#{titleStr}#{newLine}"
				plistStr += "RTINSECONDS=#{rtimeVal}#{newLine}"
				plistStr += "#{ms2Str}#{newLine}"
				plistStr += "END IONS#{newLine}"
#p plistStr
#exit(0)

				wfp.write(plistStr)

				next
			end


			# @multiPre = falseの場合のピークリスト
			rtimeTop = nil
			preGrAry.each{|aItemAry|
				(scanNo,rtimeVal,preVal,preInt,preChg,lastEqPos,rfp,plistProgAry,rawFilebase) = aItemAry

				if(rtimeTop == nil)
					rtimeTop = rtimeVal
				end

				rtimeStr = sprintf("%#.#{rtimeRound}f",rtimeTop.to_f().round(rtimeRound) / 60)
				preValStr = sprintf("%#.#{preRound}f",preVal.to_f().round(preRound))
				titleStr = self.getTitleStr(msRawType,scanNo,rtimeStr,preValStr,preChg,rawFilebase,plistProgAry,@rawFilePath)


				plistStr = newLine
				plistStr += "BEGIN IONS#{newLine}"
				if(preInt == "")
					plistStr += "PEPMASS=#{preValStr}#{newLine}"
				else
					plistStr += "PEPMASS=#{preValStr} #{preInt}#{newLine}"
				end
				if(preChg != '')
					plistStr += "CHARGE=#{preChg}#{newLine}"
				end
				plistStr += "TITLE=#{titleStr}#{newLine}"
				plistStr += "RTINSECONDS=#{rtimeTop}#{newLine}"
				plistStr += "#{ms2Str}#{newLine}"
				plistStr += "END IONS#{newLine}"
#p plistStr
#exit(0)

				wfp.write(plistStr)
			}
		}
		wfp.close()
	end
end

#!/usr/bin/env runghc

-- run <script> <number>

import Data.List (sort)
import System.Environment (getArgs)

isSq :: Int -> Bool
isSq n = (n >= 0) && ((fromIntegral (floor sqn)) == sqn) where
  sqn :: Double
  sqn = sqrt $ fromIntegral n

isRare :: Int -> Bool
isRare n = isSq (n + m) && isSq (n - m) where
  m = (read::String->Int) . reverse . show $ n

rarePals :: Int -> [String]
rarePals d = filter (\s -> isSq $ (2*) $ (read::String->Int) s) $ map (\n -> (show n) ++ (reverse $ take rest $ show n)) $ [10^(halfdigs-1)..10^halfdigs -1] where
  rest = div d 2
  halfdigs = d - rest

baseNrs :: [String]
baseNrs = ["65","621770","281089082","2022652202","2042832002","868591084757","872546974178","872568754178","6979302951885","20313693904202","20313839704202","20331657922202","20331875722202","20333875702202","40313893704200","40351893720200","200142385731002","204238494066002","221462345754122","244062891224042","245518996076442","248359494187442","403058392434500","441054594034340","816984566129618","2078311262161202","2133786945766212","2135568943984212","2135764587964212","2135786765764212","4135786945764210","6157577986646405","6889765708183410","8052956026592517","8052956206592517","8191154686620818","8191156864620818","8191376864400818","8650327689541457","8650349867341457","22542040692914522","67725910561765640","86965750494756968","225342456863243522","225342458663243522","225342478643243522","284684666566486482","284684868364486482","297128548234950692","297128722852950692","297148324656930692","297148546434930692","497168548234910690","619431353040136925","619631153042134925","631688638047992345","633288858025996145","633488632647994145","653488856225994125","811865096390477018","865721270017296468","871975098681469178","898907259301737498","2042401829204402402","2060303819041450202","2420424089100600242","2551755006254571552","2702373360882732072","2825378427312735282","6531727101458000045","6988066446726832640","8066308349502036608","8197906905009010818","8200756128308135597","8320411466598809138","22134434735752443122","22134434753752443122","22134436953532443122","22136414517954423122","22136414971554423122","22136456771730423122","61952807156239928885","61999171315484316965","65459144877856561700","208393425242000083802","219518549668074815912","257661195832219326752","286694688797362186682","837982875780054779738","2414924301133245383042","2414924323311045383042","2414946523311023183042","2576494891793995836752","2576494893971995836752","2620937863931054483162","2620937863931054483162","2620955641393276283162","2622935621573476481162","2622935643751276481162","2622937641933274481162","2622955841933256281162","2622957843751254281162","2727651947516658327272","2747736918335953517072","2788047668617596408872","2788047848617776408872","2788047868437576408872","2788047888617376408872","2939501759705522349392","2939503375709360349392","2939503537707740349392","2939521359525562149392","2939521557527542149392","2939523577527340149392","2939523779525320149392","2959503377707360349192","6344828989519887483525","8045841652464561594308","8045841654642561594308","8655059576513659814468","8655059772157639814468","8655079374155679614468","8655079574515659614468","8888070771864228883913"]

allRare :: Int -> [String]
allRare d
  |d <= 22 = sort $ (filter ((d==) . length) baseNrs) ++ (rarePals d)
  |otherwise = map show $ filter isRare [10^(d-1)..10^d-1]

main = do
  digs <- getArgs >>= return . (read::String->Int) . head
  mapM_ putStrLn $ allRare digs

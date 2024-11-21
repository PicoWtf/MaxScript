
global vk
global hk
global tk
global bk
global SetTcbIni = "C:\MaxPath\SetTcbIni.ini"
global OpenPos_X 
global OpenPos_Y 
-- selectTime = sliderTime
--  selectBone = $
--  

	if ( getIniSetting SetTcbIni  "OpenPos"  "X" ) =="" then ( SetIniSetting SetTcbIni  "OpenPos"  "X" "50" )
		else (
			OpenPos_X = getIniSetting SetTcbIni  "OpenPos"  "X"
			OpenPos_X = 	execute OpenPos_X
			)
	if ( getIniSetting SetTcbIni  "OpenPos"  "Y" ) =="" then ( SetIniSetting SetTcbIni  "OpenPos"  "Y" "100" )
		else (
			OpenPos_Y = getIniSetting SetTcbIni  "OpenPos"  "Y"
			OpenPos_Y = 	execute OpenPos_Y
			)
				




 
FN GetSeleteKey  selectBone =  --获取当前骨骼被选择的关键帧-目前紧职称bip骨骼
(
	GetSeleteKeyArray = #()
	bip = selectBone.transform.controller
	keysArray = bip.keys
	
	if keysArray.count==0 do return GetSeleteKeyArray
	for i = 1 to keysArray.count do
	(
		if keysArray[i].selected ==true do
		(
			append GetSeleteKeyArray i
			)
		
		
		)
	
	return GetSeleteKeyArray
	
	)
 

FN BoneKey selectBone selectTime  =  --bone骨骼增加关键帧
(
	
	selectBone_pos = selectBone.position.controller.keys
	selectBone_rot = selectBone.rotation.controller.keys
	selectBone_scale = selectBone.scale.controller.keys
 
 
	 addNewKey selectBone_pos   selectTime
	 addNewKey selectBone_rot   selectTime
	 addNewKey selectBone_scale selectTime
	
	)




FN BipKey selectBone  selectTime =   --bip 获得Keys
(
 
bip = selectBone.transform.controller
biped.addNewKey bip selectTime
keysNub=0
 keysArray = bip.keys
 for i = 1 to keysArray.count do  --获得当前帧数组序号
	(
		if  sliderTime ==  keysArray[i].time do
		(			
			keysNub = i
			exit
			)		
	)
 bk = biped.getKey bip keysNub
return bk
)
 --showproperties bk.ikSpace = 1



FN SetIk  BoneArray = --将选中的骨骼设置为ik
(
		try 
		(biped.setSlidingKey BoneArray )
		catch( )
			
	)
	
FN SetFk  boneArray = --将选中的骨骼设置为Fk
(

		try 
		(biped.setFreeKey BoneArray )
		catch( )
			
	)
	
FN SetPk  boneArray = --将选中的骨骼设置为Pk
(
	try 
		(biped.setPlantedKey BoneArray)
		catch( )
			
	)


 

Fn PanDuanIKPyte  selectBone  selectTime =  --检查当前所选的骨骼是否有IK属性。
(

	
	try(
	BipKey selectBone  selectTime
	)
	catch ( return  false )
	
	try ( 
		bk.ikPivotIndex
		return true
		)
	catch ( return  false )
		
	)





Fn VerticalKey  selectBone  selectTime =   --垂直KeyFn
(
	 bip = selectBone.transform.controller
	 vertCont = bip.vertical.controller   --垂直子控制器
	 biped.addNewKey vertCont selectTime  --在垂直控制器上添加一帧
	 keysArray =  vertCont.keys  --获得关键帧数组
	keysNub=0
	for i = 1 to keysArray.count do  --获得当前帧数组序号
	(
		if  selectTime ==  keysArray[i].time do
		(			
			keysNub = i
			exit
			)		
	)
	 vk = biped.getKey vertCont keysNub --获得当前帧子控制器的key
	 return vk
	)
	

Fn HorizontalKey  selectBone  selectTime =   --水平KeyFn
(
	 bip = selectBone.transform.controller
	 horzCont = bip.horizontal.controller   --水平
	 biped.addNewKey  horzCont  selectTime
	keysArray =  horzCont.keys  --获得关键帧数组
	keysNub=0
	for i = 1 to keysArray.count do  --获得当前帧数组序号
	(
		if  sliderTime ==  keysArray[i].time do
		(			
			keysNub = i
			exit
			)		
		)
	
	 hk = biped.getKey horzCont  keysNub --获得子控制器的key
	 return hk
	)
	

Fn TurningKey  selectBone  selectTime =   --旋转KeyFn
(
	 bip = selectBone.transform.controller
	 turnCont = bip.turning.controller    --旋转
	 biped.addNewKey turnCont selectTime
	keysArray =  turnCont.keys  --获得关键帧数组
	keysNub=0
	for i = 1 to keysArray.count do  --获得当前帧数组序号
	(
		if  sliderTime ==  keysArray[i].time do
		(			
			keysNub = i

			exit
			)		
		)
	
	 tk = biped.getKey turnCont  keysNub   --获得控制器的dey  的第几个关键帧
	return tk
	)
	global selectBip001Teyp = 4  -- 初始等于4 确保All初始就能用
	global Bip001ArrayNub  = #() --bip001的下标
	global BipArrayNub  = #() --bip骨骼下标
	global BoneArray = #() --所选的所有物体
	global maxBoneArrayNub = #()  --非bip骨骼的下标
	
	BoneArray = selection as array
	
FN PanDuanGuGeShuXing  BoneArray =  --生成三个个数组，一个包含bip001下标号  另一个包含其它bip骨骼得下标号 另一个保护bone骨骼下标
	(
		Bip001ArrayNub = #()
		BipArrayNub = #()
		maxBoneArrayNub = #()
		
		for i = 1 to  BoneArray.count do
		(
			try   --如果报错就是bip其它骨骼。
			(	
				if BoneArray[i].transform.controller.bodyType == 0 or 
					BoneArray[i].transform.controller.bodyType == 1 or
					BoneArray[i].transform.controller.bodyType == 2 or
					BoneArray[i].transform.controller.bodyType == 3 do
					(append Bip001ArrayNub i )
			
			)
			catch ( continue )
		)
		
		for u = 1 to BoneArray.count do  --判断是否为bip其他骨骼
		(
			try 
			(
				bipRootNode = (BoneArray[u].transform.controller.rootNode) as string
				if ( findstring bipRootNode "$Biped_Object" != undefined ) then				
				(append BipArrayNub u )--如果是bip就加入bip的组内
			)
			
			catch ( 
				
				continue 
			)
			
		)
		for t = 1 to 	BoneArray.count do
		(
			
			try 
			(
				BoneArray[t].width    
				append maxBoneArrayNub t
			)
			
			catch ( 
				
				continue 
			)
			
			)
		for t = 1 to 	BoneArray.count do  --如果是相机就加入 maxbonearraynub数组
			
		(
			
			try 
			(
				BoneArray[t].fov   
				append maxBoneArrayNub t
			)
			
			catch ( 
				
				continue 
			)
			
			)
			
		for t = 1 to 	BoneArray.count do  --如果是Dummy 就加入maxbonearraynub数组
			
		(
			
			try 
			(
				BoneArray[t].boxsize  
				append maxBoneArrayNub t
			)
			
			catch ( 
				
				continue 
			)
			
			)
		
		
		for y = 1 to Bip001ArrayNub.count do   --如果BipArrayNub数组中包含得Bip001ArrayNub，就将其删除
		(
			for t = 1 to  BipArrayNub.count do 
			(
				if Bip001ArrayNub[y] == BipArrayNub[t] do
				(   deleteItem BipArrayNub t )
			)
			
			
			)
	)
	
	
FN PanDuanSuoXuan  = -- 判断所选节点是否合规
	(
		BoneArray = selection as array
		
		if BoneArray.count == 0 then 
			(
				messagebox "嘿！！老伙计你没有选择任何节点！！" title:"一点也不温馨的提示" 
				
				BoneArray = #()
				return  BoneArray
				
				)
		
		else
		(
			PanDuanGuGeShuXing  BoneArray
			
			if Bip001ArrayNub.count == 0 and BipArrayNub.count == 0  do
			
			(
				messagebox "嘿！！老伙计你没有选择Biped节点！！" title:"一点也不温馨的提示"
			
			BoneArray = #()
			return  BoneArray	
				) 
				
			)
		return  BoneArray	
		)
	
FN Bip001SetEaseTo  tcbTeypValue bip001Xiabiao   =   --bip的tcb属性淡入设置，传参是tcb属性值 和bip001数组下标
		(
			
			if selectBip001Teyp == 1 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				HorizontalKey  selectBone  selectTime
				hk.EaseTo   =  tcbTeypValue
				)
				if selectBip001Teyp == 2 do 
				(
				
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				VerticalKey  selectBone  selectTime
				vk.EaseTo  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 3 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				tk.EaseTo  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 4 do 
				(
					
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				VerticalKey  selectBone  selectTime
				HorizontalKey  selectBone  selectTime
				hk.EaseTo   =  tcbTeypValue	
				vk.EaseTo  =  tcbTeypValue
				tk.EaseTo =  tcbTeypValue
				)
			
		)
		
		
		
FN Bip001SetEaseFrom  tcbTeypValue bip001Xiabiao   =   --bip的tcb属性淡入设置，传参是tcb属性值 和bip001数组下标
		(
			
			if selectBip001Teyp == 1 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				HorizontalKey  selectBone  selectTime
				hk.EaseFrom   =  tcbTeypValue
				)
				if selectBip001Teyp == 2 do 
				(
				
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				VerticalKey  selectBone  selectTime
				vk.EaseFrom  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 3 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				tk.EaseFrom  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 4 do 
				(
					
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				VerticalKey  selectBone  selectTime
				HorizontalKey  selectBone  selectTime
				hk.EaseFrom   =  tcbTeypValue	
				vk.EaseFrom  =  tcbTeypValue
				tk.EaseFrom =  tcbTeypValue
				)
			
		)
		
		FN Bip001SetTension  tcbTeypValue bip001Xiabiao   =   --bip的tcb属性张力设置，传参是tcb属性值 和bip001数组下标
		(
			
			if selectBip001Teyp == 1 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				HorizontalKey  selectBone  selectTime
				hk.Tension   =  tcbTeypValue
				)
				if selectBip001Teyp == 2 do 
				(
				
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				VerticalKey  selectBone  selectTime
				vk.Tension  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 3 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				tk.Tension  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 4 do 
				(
					
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				VerticalKey  selectBone  selectTime
				HorizontalKey  selectBone  selectTime
				hk.Tension   =  tcbTeypValue	
				vk.Tension  =  tcbTeypValue
				tk.Tension =  tcbTeypValue
				)
			
		)


		
FN Bip001SetContinuity  tcbTeypValue bip001Xiabiao   =   --bip的tcb属性连续性设置，传参是tcb属性值 和bip001数组下标
		(
			
			if selectBip001Teyp == 1 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				HorizontalKey  selectBone  selectTime
				hk.Continuity   =  tcbTeypValue
				)
				if selectBip001Teyp == 2 do 
				(
				
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				VerticalKey  selectBone  selectTime
				vk.Continuity  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 3 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				tk.Continuity  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 4 do 
				(
					
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				VerticalKey  selectBone  selectTime
				HorizontalKey  selectBone  selectTime
				hk.Continuity   =  tcbTeypValue	
				vk.Continuity  =  tcbTeypValue
				tk.Continuity =  tcbTeypValue
				)
			
		)
		

FN Bip001SetBias  tcbTeypValue bip001Xiabiao   =   --bip的tcb属性连续性设置，传参是tcb属性值 和bip001数组下标
		(
			
			if selectBip001Teyp == 1 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				HorizontalKey  selectBone  selectTime
				hk.Bias   =  tcbTeypValue
				)
				if selectBip001Teyp == 2 do 
				(
				
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				VerticalKey  selectBone  selectTime
				vk.Bias  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 3 do 
				(
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				tk.Bias  =  tcbTeypValue
				
				)
				if selectBip001Teyp == 4 do 
				(
					
				selectBone = BoneArray[Bip001ArrayNub[bip001Xiabiao]]
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				VerticalKey  selectBone  selectTime
				HorizontalKey  selectBone  selectTime
				hk.Bias   =  tcbTeypValue	
				vk.Bias  =  tcbTeypValue
				tk.Bias =  tcbTeypValue
				)
			
		)
		
FN  BipSetEaseTo tcbTeypValue bipXiabiao   =   --bip设置淡出
			(
				selectBone = BoneArray[BipArrayNub[bipXiabiao]]
				selectTime = sliderTime
				BipKey  selectBone  selectTime
				bk.EaseTo =  tcbTeypValue
				
				)
				
FN  BipSetEaseFrom tcbTeypValue bipXiabiao   =   --bip设置淡出
			(
				selectBone = BoneArray[BipArrayNub[bipXiabiao]]
				selectTime = sliderTime
				BipKey  selectBone  selectTime
				bk.EaseFrom =  tcbTeypValue
				
				)
				
	FN  BipSetTension tcbTeypValue bipXiabiao   =   --bip设置张力
			(
				selectBone = BoneArray[BipArrayNub[bipXiabiao]]
				selectTime = sliderTime
				BipKey  selectBone  selectTime
				bk.Tension =  tcbTeypValue
				
				)

		FN  BipSetContinuity tcbTeypValue bipXiabiao   =   --bip设置连续性
			(
				selectBone = BoneArray[BipArrayNub[bipXiabiao]]
				selectTime = sliderTime
				BipKey  selectBone  selectTime
				bk.Continuity =  tcbTeypValue
				
				)

FN  BipSetBias tcbTeypValue bipXiabiao   =   --bip设置偏移
			(
				selectBone = BoneArray[BipArrayNub[bipXiabiao]]
				selectTime = sliderTime
				BipKey  selectBone  selectTime
				bk.Bias =  tcbTeypValue
				
				)	
	
	global	YY_max_V_int		
	fn max_Version =
(
max_V = GetFileVersion (getDir #maxRoot + "\\3dsmax.exe")  -- 获取当前max版本号
YY_v = substring max_V 1 2  -- 返回字符串中从第一个到第二个字符
case of 
(
    (YY_v == "10"): (YY_max_V = "2008")
    (YY_v == "11"): (YY_max_V = "2010")
    (YY_v == "13"): (YY_max_V = "2011")
    (YY_v == "14"): (YY_max_V = "2012")
    (YY_v == "15"): (YY_max_V = "2013")
    (YY_v == "16"): (YY_max_V = "2014")
    (YY_v == "17"): (YY_max_V = "2015")
	(YY_v == "18"): (YY_max_V = "2016")
	(YY_v == "19"): (YY_max_V = "2017")
	(YY_v == "20"): (YY_max_V = "2018")
	(YY_v == "21"): (YY_max_V = "2019")
	(YY_v == "22"): (YY_max_V = "2020")
	(YY_v == "23"): (YY_max_V = "2021")
	(YY_v == "24"): (YY_max_V = "2022")
	(YY_v == "25"): (YY_max_V = "2023")
    )
	
 YY_max_V_int =   execute 	YY_max_V
return YY_max_V
)	
	





rollout SetTCB "SetTCB" width:189 height:333
(
	

	label 'lbl2' "缓入" pos:[4,63] width:30 height:14 align:#left
	label 'lbl3' "缓出" pos:[4,81] width:30 height:14 align:#left
	button 'HuanRu_0' "0" pos:[39,63] width:29 height:17 align:#left
	button 'HuanRu_25' "25" pos:[68,63] width:29 height:17 align:#left
	button 'HuanRu_50' "50" pos:[97,64] width:29 height:17 align:#left
	spinner 'HuanRu_T' "" pos:[127,63] width:37 height:16 range:[0,50,25] type:#float scale:1 indeterminate:true align:#left
	button 'HuanChu_0' "0" pos:[39,81] width:29 height:17 align:#left
	button 'HuanChu_25' "25" pos:[68,81] width:29 height:17 align:#left
	button 'HuanChu_50' "50" pos:[97,81] width:29 height:17 align:#left
	spinner 'HuanChu_T' "" pos:[127,81] width:37 height:16 range:[0,50,25] type:#float scale:1 indeterminate:true align:#left
	label 'lbl4' "张力" pos:[3,104] width:31 height:14 align:#left
	button 'Zhangli_0' "0" pos:[39,104] width:29 height:17 align:#left
	button 'Zhangli_25' "25" pos:[68,104] width:29 height:17 align:#left
	button 'Zhangli_50' "50" pos:[97,104] width:29 height:17 align:#left
	spinner 'Zhangli_T' "" pos:[127,104] width:37 height:16 range:[0,50,25] type:#float scale:1 indeterminate:true align:#left
	label 'lbl5' "连续性" pos:[3,121] width:42 height:14 align:#left
	button 'Lianxuxing_0' "0" pos:[39,121] width:29 height:17 align:#left
	button 'Lianxuxing_25' "25" pos:[68,121] width:29 height:17 align:#left
	button 'Lianxuxing_50' "50" pos:[97,121] width:29 height:17 align:#left
	spinner 'Lianxuxing_T' "" pos:[127,121] width:37 height:16 range:[0,50,25] type:#float scale:1 indeterminate:true align:#left
	label 'lbl6' "偏移" pos:[1,139] width:37 height:14 align:#left
	button 'PianYi_0' "0" pos:[39,138] width:29 height:17 align:#left
	button 'PianYi_25' "25" pos:[68,138] width:29 height:17 align:#left
	button 'PianYi_50' "50" pos:[97,138] width:29 height:17 align:#left
	spinner 'PianYi_T' "" pos:[127,138] width:37 height:16 range:[0,50,25] type:#float scale:1 indeterminate:true align:#left
	radiobuttons 'Bip001Teyp' "" pos:[9,21] width:153 height:32 labels:#("水平", "垂直", "旋转", "All") default:4 columns:3 align:#left
	GroupBox 'grp1' "Bip001Teyp" pos:[8,6] width:161 height:53 align:#left
	button 'dabaoxuanze' "打包选择" pos:[15,157] width:81 height:20 align:#left
	button 'zhuanbanben' "转版本" pos:[85,292] width:45 height:19 align:#left
	checkbox 'piliang' "批量" pos:[134,291] width:42 height:19 align:#left
	dropdownList 'banbenhao' "" pos:[5,291] width:76 height:22 items:#("") selection:1 align:#left	
	
	
	progressBar 'jindu' "ProgressBar" pos:[0,313] width:187 height:8 color:(color 255 255 0) align:#left
	button 'point_8' "" pos:[30,214] width:17 height:17 align:#left
	button 'point_5' "" pos:[12,231] width:17 height:17 align:#left
	button 'point_6' "" pos:[30,231] width:17 height:17 align:#left
	button 'point_7' "" pos:[48,231] width:17 height:17 align:#left
	button 'point_1' "" pos:[30,248] width:17 height:17 align:#left
	button 'point_2' "" pos:[13,265] width:17 height:17 align:#left
	button 'point_3' "" pos:[30,265] width:17 height:17 align:#left
	button 'point_4' "" pos:[48,265] width:17 height:17 align:#left
	GroupBox 'grp2' "KeyInfo" pos:[3,201] width:174 height:85 align:#left
	button 'AllIK' "IK" pos:[70,222] width:27 height:18 align:#left
	button 'AllFK' "FK" pos:[70,243] width:27 height:18 align:#left
	button 'AllPK' "PK" pos:[70,264] width:27 height:18 align:#left
	button 'key' "Key" pos:[50,35] width:100 height:21 toolTip:"将选中的所有物体添加关键帧。" align:#left
	button 'SelectIK' "S_IK" pos:[101,222] width:33 height:18 toolTip:"将当前被选择的关键帧设置为IK" align:#left
	button 'SelectFK' "S_FK" pos:[101,243] width:33 height:18 toolTip:"将当前被选择的关键帧设置为FK" align:#left
	button 'SelectPK' "S_PK" pos:[101,264] width:33 height:18 toolTip:"将当前被选择的关键帧设置为PK" align:#left
	button 'A_IK' "A_IK" pos:[137,222] width:33 height:18 toolTip:"将当前时间轴内的所有关键帧设置为IK" align:#left
	button 'A_FK' "A_FK" pos:[137,243] width:33 height:18 toolTip:"将当前时间轴内的所有关键帧设置为FK" align:#left
	button 'A_PK' "A_PK" pos:[137,264] width:33 height:18 toolTip:"将当前时间轴内的所有关键帧设置为PK" align:#left
	
	
		
	
fn GetTcb =   --显示Tcb
(
	try
	(
	HuanRu_T.Indeterminate = true 
	HuanChu_T.Indeterminate = true 
	Zhangli_T.Indeterminate = true 
	Lianxuxing_T.Indeterminate = true 
	PianYi_T.Indeterminate = true 
	BoneArray = selection as array
		
		
	PanDuanGuGeShuXing  BoneArray
	
		
	if BipArrayNub.count == 1 then
	(
		bip = BoneArray[BipArrayNub[1]].transform.controller
		--biped.addNewKey bip selectTime
		keysNub=0
		keysArray = bip.keys
		for i = 1 to keysArray.count do  --获得当前帧数组序号
		(
			if  sliderTime ==  keysArray[i].time then
			(		
				keysNub = i
				bk = biped.getKey bip keysNub
				HuanRu_T.value =   bk.EaseTo
				HuanChu_T.value =   bk.EaseFrom
				Zhangli_T.value =  bk.Tension
				Lianxuxing_T.value =  bk.Continuity
				PianYi_T.value =  bk.Bias
				HuanRu_T.Indeterminate = false
				
				if bk.ikPivotIndex == 1 do 
					(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = "O"
						)

					if bk.ikPivotIndex == 2 do 
					(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = "O"
							point_1.caption = ""
						)
					if bk.ikPivotIndex == 3 do 
					(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = "O"
							point_2.caption = ""
							point_1.caption = ""
						)
					if bk.ikPivotIndex == 4 do 
					(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = "O"
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = ""
						)
					if bk.ikPivotIndex == 5 do 
					(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = "O"
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = ""
						)
					if bk.ikPivotIndex == 6 do 
					(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = "O"
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = ""
						)
					if bk.ikPivotIndex == 7 do 
					(
							point_8.caption = ""
							point_7.caption = "O"	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = ""
						)
					if bk.ikPivotIndex == 8 do 
					(
							point_8.caption = "O"
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = ""
						)
				exit
				)
				else 
				(
							point_8.caption = ""
							point_7.caption = ""	
							point_6.caption = ""
							point_5.caption = ""
							point_4.caption = ""
							point_3.caption = ""
							point_2.caption = ""
							point_1.caption = ""
					
					
					)
			
		)
		
	)
	else
	(
			if Bip001ArrayNub.count == 1 do  --如果bip001的数组下标 等于1
			(
				if selectBip001Teyp == 1 do  --如果旋转水平，就获取垂直的属性
				(
					bip = BoneArray[Bip001ArrayNub[1]].transform.controller
					horzCont = bip.horizontal.controller   --水平
					keysArray =  horzCont.keys  --获得关键帧数组
					keysNub=0
				for i = 1 to keysArray.count do  --获得当前帧数组序号
				(
					if  sliderTime ==  keysArray[i].time do
					(			
					keysNub = i
					hk = biped.getKey horzCont keysNub
					HuanRu_T.value =   hk.EaseTo
					HuanChu_T.value =   hk.EaseFrom
					Zhangli_T.value =  hk.Tension
					Lianxuxing_T.value =  hk.Continuity
					PianYi_T.value =  hk.Bias
					HuanRu_T.Indeterminate = false
						
					
					exit
					)		
				)	
			)
			
			
			if selectBip001Teyp == 2 do  --如果旋转垂直，就获取垂直的属性
			(
			
				bip = BoneArray[Bip001ArrayNub[1]].transform.controller
				vertCont = bip.vertical.controller   --垂直子控制器
				keysArray =  vertCont.keys  --获得关键帧数组
				keysNub=0
				for i = 1 to keysArray.count do  --获得当前帧数组序号
				(
					if  sliderTime ==  keysArray[i].time do
					(			
					keysNub = i
					vk = biped.getKey vertCont keysNub
					HuanRu_T.value =   vk.EaseTo
					HuanChu_T.value =   vk.EaseFrom
					Zhangli_T.value =  vk.Tension
					Lianxuxing_T.value =  vk.Continuity
					PianYi_T.value =  vk.Bias
					HuanRu_T.Indeterminate = false
					exit
					)		
				)	
			)
			
				if selectBip001Teyp == 3 do  --如果旋转垂直，就获取垂直的属性
				(
			
				bip = BoneArray[Bip001ArrayNub[1]].transform.controller
				turnCont = bip.turning.controller  --旋转控制器
				keysArray =  turnCont.keys  --获得关键帧数组
				keysNub=0
				for i = 1 to keysArray.count do  --获得当前帧数组序号
					(
						if  sliderTime ==  keysArray[i].time do
						(			
						keysNub = i
						tk = biped.getKey turnCont keysNub
						HuanRu_T.value =   tk.EaseTo
						HuanChu_T.value =   tk.EaseFrom
						Zhangli_T.value =  tk.Tension
						Lianxuxing_T.value =  tk.Continuity
						PianYi_T.value =  tk.Bias
						HuanRu_T.Indeterminate = false
						exit
					)		
					)	
				)
			
			
			
			
			
			)
		
		
		
		
	)
	
	)
	catch ()
	
)
	
	

	
	

	button 'xuanzebip001' "选择Bip001" pos:[97,157] width:67 height:20 align:#left
	button 'dongjie' "冻结" pos:[51,180] width:44 height:18 align:#left
	button 'jiedong' "解冻" pos:[97,180] width:44 height:18 align:#left
	button 'btnSet' "Set" pos:[157,3] width:31 height:13 align:#left


	on SetTCB open do
	(
		
		max_Version()
		YY_max_V_int		
		V_1 = (YY_max_V_int - 1) as string
		V_2 = (YY_max_V_int - 2) as string
		V_3 = (YY_max_V_int - 3) as string
		banbenhao.items = #(V_1,V_2,V_3)
	--unRegisterRedrawViewsCallback	GetTcb
	registerTimeCallback GetTcb  --时间检测机制，当时间轴发生变化时执行后面的函数
		 
		
		--设置启动位置
	
		
		)
	on btnSet pressed do 
	(

		rollout Rollout_SetTCBSetTools "SetTCB设置器" width:225 height:128
		(
			edittext 'Rollout_SetTCBSetTools_spnX' "X" pos:[16,36] width:74 height:16 align:#left
			edittext 'Rollout_SetTCBSetTools_spnY' "Y" pos:[107,36] width:74 height:16 range:[0,100,0] align:#left
			groupBox 'grp3' "编辑启动位置" pos:[6,12] width:198 height:51 align:#left
			button 'Rollout_SetTCBSetTools_btnQueding' "确定" pos:[28,77] width:158 height:29 align:#left
			
			on Rollout_SetTCBSetTools open do 
		(
 			Rollout_SetTCBSetTools_spnX.text = OpenPos_X as string
			Rollout_SetTCBSetTools_spnY.text = OpenPos_Y as string
			)
		on 	Rollout_SetTCBSetTools_btnQueding  pressed do
		(
			SetIniSetting SetTcbIni  "OpenPos"  "X"  (Rollout_SetTCBSetTools_spnX.text )
			
			SetIniSetting SetTcbIni  "OpenPos"  "Y"  (Rollout_SetTCBSetTools_spnY.text )
	
			messagebox "设置完成，重启生效"
			destroyDialog Rollout_SetTCBSetTools
			)
		)
		
		PoseEditpos =  GetDialogPos  SetTCB  --获取主窗口在屏幕中的位
		
		PoseEditpos = PoseEditpos + [180,30]  --创建一个新的rollout位置
		
		createdialog 	Rollout_SetTCBSetTools  pos:PoseEditpos
			
		)
		
		
	on HuanRu_0 pressed do
	(
		
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		HuanRu_T.value = 0
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseTo  0  i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseTo 0 o 
				
			)	
			
		
		)
	)
	
	)
	on HuanRu_25 pressed do
	(
		
		PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
			
		HuanRu_T.value = 25
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseTo  25  i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseTo 25 o 
				
			)	
			
		
		)
	)
	
	)
	on HuanRu_50 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		HuanRu_T.value = 50
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseTo  50 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseTo 50 o 
				
			)	
			
		
		)
	)
	
	)
	on HuanRu_T buttonup do   --滑动调节 渐入
	(
	 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseTo  HuanRu_T.value  i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseTo HuanRu_T.value o 
				
			)	
			
		
		)
	)
	 
	)
	on HuanChu_0 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		HuanChu_T.value = 0
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseFrom  0 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseFrom 0 o 
				
			)	
			
		
		)
	)
	
	)
	on HuanChu_25 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		HuanChu_T.value = 25
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseFrom  25 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseFrom 25 o 
				
			)	
			
		
		)
	)
	
	)
	on HuanChu_50 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		HuanChu_T.value = 50
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseFrom  50 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseFrom 50 o 
				
			)	
			
		
		)
	)
	
	)
	on HuanChu_T buttonup do   --滑动调节 渐出
	(
	 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetEaseFrom  HuanChu_T.value  i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetEaseFrom HuanChu_T.value o 
				
			)	
			
		
		)
	)
	 
	)
	on Zhangli_0 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Zhangli_T.value = 0
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetTension  0 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetTension 0 o 
				
			)	
			
		
		)
	)
	
	)
	on Zhangli_25 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Zhangli_T.value = 25
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetTension  25 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetTension 25 o 
				
			)	
			
		
		)
	)
	
	)
	on Zhangli_50 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Zhangli_T.value = 50
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetTension  50 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetTension 50 o 
				
			)	
			
		
		)
	)
	
	)
	on Zhangli_T buttonup do   --滑动调节 张力
	(
	 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetTension  Zhangli_T.value  i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetTension Zhangli_T.value o 
				
			)	
			
		
		)
	)
	 
	)
	on Lianxuxing_0 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Lianxuxing_T.value = 0
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetContinuity 0 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetContinuity 0 o 
				
			)	
			
		
		)
	)
	
	)
	on Lianxuxing_25 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Lianxuxing_T.value = 25
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetContinuity 25 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetContinuity 25 o 
				
			)	
			
		
		)
	)
	
	)
	on Lianxuxing_50 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Lianxuxing_T.value = 50
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetContinuity 50 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetContinuity 50 o 
				
			)	
			
		
		)
	)
	
	)
	on Lianxuxing_T buttonup do   --滑动调节 连续性
	(
	 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetContinuity  LianXuXing_T.value  i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetContinuity LianXuXing_T.value o 
				
			)	
			
		
		)
	)
	 
	)
	on PianYi_0 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Pianyi_T.value = 0
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetBias 0 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetBias 0 o 
				
			)	
			
		
		)
	)
	
	)
	on PianYi_25 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Pianyi_T.value = 25
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetBias 25 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetBias 25 o 
				
			)	
			
		
		)
	)
	
	)
	on PianYi_50 pressed do
	(
		
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
		
	for u = 1 to 1 do 
	(
		
		if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
		
		Pianyi_T.value = 50
		
		if Bip001ArrayNub.count != 0 do 
		(
			for i = 1 to Bip001ArrayNub.count do 
			(
				
			Bip001SetBias 50 i			
			)
		)
	 		
		if BipArrayNub.count != 0 do 
		(
			
			
			for o = 1 to BipArrayNub.count do 
			(
				
				BipSetBias 50 o 
				
			)	
			
		
		)
	)
	
	)
	on PianYi_T buttonup do   --滑动调节 连续性
	(
		 PanDuanSuoXuan () --判断选择是否合规 以及生成数组以及下标
			
		for u = 1 to 1 do 
		(
			
			if Bip001ArrayNub.count== 0  and  BipArrayNub.count == 0  do exit  --如果没有选择骨骼就退出
			
			
			
			if Bip001ArrayNub.count != 0 do 
			(
				for i = 1 to Bip001ArrayNub.count do 
				(
					
				Bip001SetBias  Pianyi_T.value  i			
				)
			)
		 		
			if BipArrayNub.count != 0 do 
			(
				
				
				for o = 1 to BipArrayNub.count do 
				(
					
					BipSetBias Pianyi_T.value o 
					
				)	
				
			
			)
		)
		 
		)
	on Bip001Teyp changed stat do
	(
								case stat of
					(
						1:
						(selectBip001Teyp=1
							GetTcb()
							)
						2:
						(selectBip001Teyp=2
							GetTcb()
							)
						3:
						(selectBip001Teyp=3
							GetTcb()
							)
						4:
						(selectBip001Teyp=4
							GetTcb()
							)
						
					)
			
		)
	on dabaoxuanze pressed do
	(
		dabaobone = #($Bip001_Pelvis,$Bip001_R_Hand,$Bip001_L_Hand,$Bip001_R_Foot,$Bip001_L_Foot,$Bip001_Spine,$Bip001_Head,$Bip001)
		
		clearSelection()
		for i = 1 to dabaobone.count do 
		(
			try( selectMore dabaobone[i])
			catch (continue)
				
			)
		)
	on zhuanbanben pressed do	 --转换版本
	(
		wenjian_lujing = maxfilepath + "\*.max" -- 得到输出路径
		shuchu_wenjian = getFiles wenjian_lujing   -- 得到这个目录下面的所有MAX文件
		banbenhao_int = execute banbenhao.selected
		jin = 100/shuchu_wenjian.count
		
		if piliang.state == 1 then
		(
		
		
		for o = 1 to 1 do 
		(
		
		banbenhao_int = execute banbenhao.selected
	
			for wenjian_i =1 to shuchu_wenjian.count do
			(
			
			jindu.value = jindu.value + jin
			if keyboard.escPressed then exit  --按esc就停止
				loadMaxFile  shuchu_wenjian[wenjian_i] useFileUnits:true quiet:true --打开文件 文件路径  使用打开场景的单位设置 静默模式（不弹出任何弹窗）	
				saveMaxFile (maxfilepath + maxfilename ) saveAsVersion:banbenhao_int
			  print banbenhao_int
			)
		)
		messagebox ("转换完成" )
		)
		
		else
		(
			jindu.value = 50
			
			jindu.value = 100
			saveMaxFile (maxfilepath + maxfilename ) saveAsVersion:banbenhao_int
			
			)
		jindu.value = 0
	)
	on point_8 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = bk.ikNumPivots
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = bk.ikNumPivots
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey	
	point_8.caption = "O"
	point_7.caption = ""	
	point_6.caption = ""
	point_5.caption = ""
	point_4.caption = ""
	point_3.caption = ""
	point_2.caption = ""
	point_1.caption = ""
	)
	on point_5 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 5
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 5
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = ""	
	point_6.caption = ""
	point_5.caption = "O"
	point_4.caption = ""
	point_3.caption = ""
	point_2.caption = ""
	point_1.caption = ""
	)
	on point_6 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 6
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 6
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = ""	
	point_6.caption = "O"
	point_5.caption = ""
	point_4.caption = ""
	point_3.caption = ""
	point_2.caption = ""
	point_1.caption = ""
	)
	on point_7 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 7
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 7
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = "O"	
	point_6.caption = ""
	point_5.caption = ""
	point_4.caption = ""
	point_3.caption = ""
	point_2.caption = ""
	point_1.caption = ""
	)
	on point_1 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 1
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 1
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = ""	
	point_6.caption = ""
	point_5.caption = ""
	point_4.caption = ""
	point_3.caption = ""
	point_2.caption = ""
	point_1.caption = "O"
		
	
	)
	on point_2 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 2
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 2
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = ""	
	point_6.caption = ""
	point_5.caption = ""
	point_4.caption = ""
	point_3.caption = ""
	point_2.caption = "O"
	point_1.caption = ""
	)
	on point_3 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 3
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 3
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = ""	
	point_6.caption = ""
	point_5.caption = ""
	point_4.caption = ""
	point_3.caption = "O"
	point_2.caption = ""
	point_1.caption = ""
	)
	on point_4 pressed do
	(
		selectAllBone = selection as array
		dangQiankey = sliderTime   --记录当前时间帧
		for i = 1 to selectAllBone.count do
		(
			selectBone = selectAllBone[i]    
			GetSeleteKeyArray =  GetSeleteKey  selectBone   --获得当前selectBone被选择的帧下标
			bip = selectBone.transform.controller
			keysArray = bip.keys   --列出序列帧数组
			
			if GetSeleteKeyArray.count != 0 then   --如果有被选择的关键帧，就执行
			(
				for o= 1 to GetSeleteKeyArray.count do 
				(
					selectTime = keysArray[GetSeleteKeyArray[o]].time
				    sliderTime = selectTime
					if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 4
					)	
				
				)
			)
			else  --如果没有被选择的关键帧就执行
			(
				selectTime = sliderTime
				if PanDuanIKPyte  selectBone  selectTime  == true  then 
					(
						BipKey selectBone  selectTime
						biped.setSlidingKey  selectAllBone[i]  --转换为ik
						bk.ikPivotIndex = 4
					)	
				
				
				)
			
		)
		sliderTime = dangQiankey
	point_8.caption = ""
	point_7.caption = ""	
	point_6.caption = ""
	point_5.caption = ""
	point_4.caption = "O"
	point_3.caption = ""
	point_2.caption = ""
	point_1.caption = ""
	)
	on AllIK pressed do
	(undo On(
		boneArray = selection as array
		
		for i= 1 to boneArray.count do
		(			
			SetIK   boneArray[i]		
		)
	))
	on AllFK pressed do
	(undo On(
		boneArray = selection as array
		
		for i= 1 to boneArray.count do
		(			
			SetFK   boneArray[i]		
		)
	))
	on AllPK pressed do
	(undo On(
		boneArray = selection as array
		
		for i= 1 to boneArray.count do
		(			
			SetPK   boneArray[i]		
		)
	))
	on key pressed do	  --所选物体K帧
	(
		undo On(
		BoneArray = selection as array
		
		PanDuanGuGeShuXing  BoneArray
		
		for i = 1 to Bip001ArrayNub.count do    --bipK帧
		(
			selectBone = BoneArray[Bip001ArrayNub[i]]
			
			if selectBip001Teyp == 1 do 
				(
				selectTime = sliderTime
				HorizontalKey  selectBone  selectTime
				)
				if selectBip001Teyp == 2 do 
				(
				selectTime = sliderTime
				VerticalKey  selectBone  selectTime
				)
				if selectBip001Teyp == 3 do 
				(				
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
								)
				if selectBip001Teyp == 4 do 
				(	
				selectTime = sliderTime
				TurningKey  selectBone  selectTime
				VerticalKey  selectBone  selectTime
				HorizontalKey  selectBone  selectTime
				)
			)
			
		for u = 1 to BipArrayNub.count do
		(			
			selectBone = BoneArray[	BipArrayNub[u]]			
			selectTime = sliderTime			
			BipKey selectBone  selectTime
			)
		
		for o = 1 to maxBoneArrayNub.count do
		(
			selectBone = BoneArray[	maxBoneArrayNub[o]]			
			selectTime = sliderTime
			
			BoneKey selectBone selectTime
			
			)
		GetTcb()
	
		
		)
		)
	on SelectIK pressed do  -- 将所选关键张设置为ik
	(
		undo On(
		boneArray = selection as array
		dangQianKey = sliderTime
		for i= 1 to boneArray.count do
		(
			selectBone = boneArray[i]  
			GetSeleteKeyArray =  GetSeleteKey  selectBone
			bip = selectBone.transform.controller
			keysArray = bip.keys
			
			
			if GetSeleteKeyArray.count!=0  then
			(
				
				for o = 1 to GetSeleteKeyArray.count do
				(
					sliderTime = keysArray[GetSeleteKeyArray[o]].time
					
					SetIK boneArray[i]
					)
				)
			else
				(
					SetIK boneArray[i]
					)
			
			
		)
		sliderTime = dangQianKey
	)
	)
	on SelectFK pressed do   -- 将所选关键张设置为Fk
	(
		undo On(
		boneArray = selection as array
		dangQianKey = sliderTime
		for i= 1 to boneArray.count do
		(
			selectBone = boneArray[i]  
			GetSeleteKeyArray =  GetSeleteKey  selectBone
			bip = selectBone.transform.controller
			keysArray = bip.keys
			
			
			if GetSeleteKeyArray.count!=0  then
			(
				
				for o = 1 to GetSeleteKeyArray.count do
				(
					sliderTime = keysArray[GetSeleteKeyArray[o]].time
					
					SetFK boneArray[i]
					)
				)
			else
				(
					SetFK boneArray[i]
					)
			
			
		)
		sliderTime = dangQianKey
	)
	)
	on SelectPK pressed do  -- 将所选关键张设置为Pk
	(
		undo On(
		boneArray = selection as array
		dangQianKey = sliderTime
		for i= 1 to boneArray.count do
		(
			selectBone = boneArray[i]  
			GetSeleteKeyArray =  GetSeleteKey  selectBone
			bip = selectBone.transform.controller
			keysArray = bip.keys
			
			
			if GetSeleteKeyArray.count!=0  then
			(
				
				for o = 1 to GetSeleteKeyArray.count do
				(
					sliderTime = keysArray[GetSeleteKeyArray[o]].time
					
					SetPK boneArray[i]
					)
				)
			else
				(
					SetPK boneArray[i]
					)
			
			
		)
		sliderTime = dangQianKey
	)
		)
	on A_IK pressed do  -- 将所选关键张设置为ik
	(
		undo On(
		boneArray = selection as array
		dangQianKey = sliderTime
		for i= 1 to boneArray.count do
		(
			selectBone = boneArray[i]  
		
			bip = selectBone.transform.controller
			keysArray = bip.keys
			
			
			if keysArray.count!=0  then
			(
				
				for o = 1 to keysArray.count do
				(
					sliderTime = keysArray[o].time
					
					SetIK boneArray[i]
					)
				)
			else
				(
					SetIK boneArray[i]
					)
			
			
		)
		sliderTime = dangQianKey
		)
	)
	on A_FK pressed do   -- 将所选关键张设置为Fk
	(
		undo On(
		boneArray = selection as array
		dangQianKey = sliderTime
		for i= 1 to boneArray.count do
		(
			selectBone = boneArray[i]  
			bip = selectBone.transform.controller
			keysArray = bip.keys
			
			
			if keysArray.count!=0  then
			(
				
				for o = 1 to keysArray.count do
				(
					sliderTime = keysArray[o].time
					
					SetFK boneArray[i]
					)
				)
			else
				(
					SetFK boneArray[1]
					)
			
			
		)
		sliderTime = dangQianKey
	)
	)
	on A_PK pressed do  -- 将所选关键张设置为Pk
	(
		undo On(
		boneArray = selection as array
		dangQianKey = sliderTime
		for i= 1 to boneArray.count do
		(
			selectBone = boneArray[1]  
			
			bip = selectBone.transform.controller
			keysArray = bip.keys
			
			
			if  keysArray.count!=0  then
			(
				
				for o = 1 to keysArray.count do
				(
					sliderTime = keysArray[o].time
					
					SetPK boneArray[i]
					)
				)
			else
				(
					SetPK boneArray[i]
					)
			
			
		)
		sliderTime = dangQianKey
		
		)
		)
	on xuanzebip001 pressed do
	(
		try (select $Bip001) catch ()
		
		)
	on dongjie pressed do
	(
		macroScript LockAllTransforms category: "HowTo"
		(
			setTransformLockFlags selection #all
			)
	
			for i in selection do setTransformLockFlags i #All
		)
	on jiedong pressed do
	(
		macroScript LockAllTransforms category: "HowTo"
		(
			setTransformLockFlags selection #all
			)
	
			for i in selection do setTransformLockFlags i #none
		
		)
)

createdialog SetTCB  	 pos:[OpenPos_X,OpenPos_Y]
	
------------------ 火华 QQ：195465970  欢迎共同学习交流。-----------
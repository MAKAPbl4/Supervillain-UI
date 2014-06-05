--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L, P, C, G = unpack(SVUI);
local Ace = LibStub("AceLocale-3.0");
local L = Ace:NewLocale("SVUI", "enUS", true, true);
if L then
	L['AURAS_DESC']='Configure the aura icons that appear near the minimap.'L["BAGS_DESC"]="Adjust bag settings for SVUI."L["CHAT_DESC"]="Adjust chat settings for SVUI."L["STATS_DESC"]="Configure docked stat panels."L["SVUI_DESC"]="SVUI is a complete User Interface replacement addon for World of Warcraft."L["NAMEPLATE_DESC"]="Modify the nameplate settings."L['PANEL_DESC']="Adjust the size of your left and right panels, this will effect your chat and bags."L["ART_DESC"]="Enable/Disable Window Modifications."L["TOGGLEART_DESC"]="Enable/Disable this change."L["TOOLTIP_DESC"]="Setup options for the Tooltip."L['TEXT_FORMAT_DESC']=[=[Provide a string to change the text format.

	Examples:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	To disable leave the field blank, if you need more information visit http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "frFR");
if L then
	L['AURAS_DESC']="Configure les icônes qui apparaissent près de la Minicarte."L["BAGS_DESC"]="Ajuster les paramètres des sacs pour SVUI."L["CHAT_DESC"]="Ajuste les paramètres du Chat pour SVUI."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI est une interface de remplacement complète pour World of Warcraft"L["NAMEPLATE_DESC"]="Modifier la configuration des noms d'unités"L["PANEL_DESC"]="Ajuste la largeur et la hauteur des fenêtres de chat, cela ajuste aussi les sacs."L["ART_DESC"]="Ajuste les paramètres d'habillage."L["TOGGLEART_DESC"]="Active ou désactive l'habillage SVUI des éléments ci-dessous."L["TOOLTIP_DESC"]="Configuration des Info-bulles."L['TEXT_FORMAT_DESC']=[=[Entrer une séquence pour changer le format du texte.

	Exemples:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	Pour désactiver, laisser le champs vide. Pour plus d'information, merci de visiter http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "deDE")
if L then
	L['AURAS_DESC']='Konfiguriere die Symbole für die Stärkungs- und Schwächungszauber nahe der Minimap.'L["BAGS_DESC"]="Konfiguriere die Einstellungen für die Taschen."L["CHAT_DESC"]="Anpassen der Chateinstellungen für SVUI."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI ist ein komplettes Benutzerinterface für World of Warcraft."L["NAMEPLATE_DESC"]="Konfiguriere die Einstellungen für die Namensplaketten."L["PANEL_DESC"]="Stellt die Größe der linken und rechten Leisten ein, dies hat auch Einfluss auf den Chat und die Taschen."L["ART_DESC"]="Passe die Einstellungen für externe Addon PrestoChange/Optionen an."L["TOGGLEART_DESC"]="Aktiviere/Deaktiviere diesen Style."L["TOOLTIP_DESC"]="Konfiguriere die Einstellungen für Tooltips."L['TEXT_FORMAT_DESC']=[=[Wähle eine Zeichenfolge um das Textformat zu ändern.

	Beispiele:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	Zum Deaktvieren lasse das Feld leer. Brauchst du mehr Informationen besuche http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "itIT");
if L then
	L['AURAS_DESC']='Configure the aura icons that appear near the minimap.'L["BAGS_DESC"]="Adjust bag settings for SVUI."L["CHAT_DESC"]="Adjust chat settings for SVUI."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI is a complete User Interface replacement addon for World of Warcraft."L["NAMEPLATE_DESC"]="Modify the nameplate settings."L['PANEL_DESC']="Adjust the size of your left and right panels, this will effect your chat and bags."L["ART_DESC"]="Adjust Style settings."L["TOGGLEART_DESC"]="Enable/Disable this style."L["TOOLTIP_DESC"]="Setup options for the Tooltip."L['TEXT_FORMAT_DESC']=[=[Provide a string to change the text format.

	Examples:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	To disable leave the field blank, if you need more information visit http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "koKR")
if L then
	L["AURAS_DESC"]="Configure the aura icons that appear near the minimap."L["BAGS_DESC"]="SVUI 위해 가방 설정을 조정합니다."L["CHAT_DESC"]="SVUI의 대화창을 설정합니다."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI는 WoW의 애드온을 대신하는 완전한 애드온입니다."L["NAMEPLATE_DESC"]="이름표의 설정을 수정합니다."L["PANEL_DESC"]="좌우 패널의 너비를 조절합니다. 이 값에 따라 대화창과 가방의 크기가 변경됩니다."L["ART_DESC"]="애드온이나 프레임의 스킨을 설정합니다."L["TOGGLEART_DESC"]="스킨 사용/중지"L["TOOLTIP_DESC"]="툴팁을 설정합니다."L['TEXT_FORMAT_DESC']=[=[Provide a string to change the text format.

	Examples:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	To disable leave the field blank, if you need more information visit http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "ptBR")
if L then
	L["AURAS_DESC"]="Configurar os ícones das auras que aparecem perto do minimapa."L["BAGS_DESC"]="Ajustar definições das bolsas para a SVUI."L["CHAT_DESC"]="Adjustar definições do bate-papo para o SVUI."L["STATS_DESC"]=true;L["SVUI_DESC"]="A SVUI é um Addon completo de substituição da interface original do World of Warcraft."L["NAMEPLATE_DESC"]="Modificar as definições das Placas de Identificação."L["PANEL_DESC"]="Ajustar o tamanho dos painéis da esquerda e direita, isto irá afetar suas bolsas e bate-papo."L["ART_DESC"]="Ajustar definições de Aparências."L["TOGGLEART_DESC"]="Ativa/Desativa a aparência deste quadro."L["TOOLTIP_DESC"]="Opções de configuração para a Tooltip."L['TEXT_FORMAT_DESC']=[=[Fornece uma sting para mudar o formato do texto.

	Examples:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	Para desactivar deixe o espaço em branco, se precisar de mais informações visite o site http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "ruRU")
if L then
	L['AURAS_DESC']='Настройка иконок эффектов, находящихся у миникарты.'L["BAGS_DESC"]="Настройки сумок SVUI"L["CHAT_DESC"]="Настройте отображение чата SVUI."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI это аддон для полной замены пользовательского интерфейса World of Warcraft."L["NAMEPLATE_DESC"]="Настройки индикаторов здоровья."L["PANEL_DESC"]="Регулирование размеров левой и правой панелей. Это окажет эффект на чат и сумки."L["ART_DESC"]="Установки скинов"L["TOGGLEART_DESC"]="Включить/выключить этот скин."L["TOOLTIP_DESC"]="Опций подсказки"L['TEXT_FORMAT_DESC']=[=[Строка для изменения вида текста.

	Примеры:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	Для отключения оставьте поле пустым, для дополнительной информации посетите http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "esES") or Ace:NewLocale("SVUI", "esMX")
if L then
	L["AURAS_DESC"]="Configura los iconos de las auras que aparecen cerca del minimapa."L["BAGS_DESC"]="Ajusta las opciones de las bolsas para SVUI."L["CHAT_DESC"]="Configura los ajustes del chat para SVUI."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI es un addon que reemplaza la interfaz completa de World of Warcraft."L["NAMEPLATE_DESC"]="Modifica las opciones de la placa de nombre"L["PANEL_DESC"]="Ajusta el tamaño de los paneles izquierdo y derecho. Esto afectará las ventanas de chat y las bolsas."L["ART_DESC"]="Configura los Ajustes de Cubiertas."L["TOGGLEART_DESC"]="Activa/Desactiva esta cubierta."L["TOOLTIP_DESC"]="Configuración para las Descripciones Emergentes."L['TEXT_FORMAT_DESC']=[=[Proporciona una cadena para cambiar el formato de texto.

	Ejemplos:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	Para desactivarlo dejar el campo en blanco, si necesitas más información visita http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "zhTW")
if L then
	L['AURAS_DESC']="小地圖旁的光環圖示設定."L["BAGS_DESC"]="調整 SVUI 背包設定."L["CHAT_DESC"]="對話框架設定."L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI 為一套功能完整, 可用來替換 WOW 原始介面的 UI 套件"L["NAMEPLATE_DESC"]="修改血條設定."L['PANEL_DESC']="調整左、右對話框的尺寸, 此設定將會影響對話與背包框架的尺寸."L["ART_DESC"]="調整外觀設定."L["TOGGLEART_DESC"]="啟用/停用此外觀."L["TOOLTIP_DESC"]="浮動提示資訊設定選項."L['TEXT_FORMAT_DESC']=[=[請填入代碼以變更文字格式。

	範例：
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	若要停用此功能，此欄位請留空。如需更多資訊，請至 http://www.wowinterface.com]=]
end
L = Ace:NewLocale("SVUI", "zhCN")
if L then
	L['AURAS_DESC']="小地图旁的光环图标设置."L["BAGS_DESC"]="调整 SVUI 背包设置."L["CHAT_DESC"]="对话框架设定"L["STATS_DESC"]=true;L["SVUI_DESC"]="SVUI 为一套功能完整，可用来替换 WOW 原始介面的套件"L["NAMEPLATE_DESC"]="修改血条设定."L['PANEL_DESC']="调整左、右对话框的大小，此设定将会影响对话与背包框架的大小."L["ART_DESC"]="调整外观设定."L["TOGGLEART_DESC"]="启用/停用此外观."L["TOOLTIP_DESC"]="鼠标提示资讯设定选项."L['TEXT_FORMAT_DESC']=[=[提供一个更改文字格式的方式

	例如:
	[namecolor][name] [difficultycolor][smartlevel] [shortclassification]
	[healthcolor][health:current-max]
	[powercolor][power:current]

	空白则为禁用. 如需技术支援请至 http://www.wowinterface.com]=]
end
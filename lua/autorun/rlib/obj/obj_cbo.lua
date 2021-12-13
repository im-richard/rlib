/*
    @library        : rlib
    @docs           : https://docs.rlib.io

    IF YOU HAVE NOT DIRECTLY RECEIVED THESE FILES FROM THE DEVELOPER, PLEASE CONTACT THE DEVELOPER
    LISTED ABOVE.

    THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
    ('CCPL' OR 'LICENSE'). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF
    THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.

    BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS
    OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS
    YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.

    UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING, LICENSOR OFFERS THE WORK AS-IS AND
    ONLY TO THE EXTENT OF ANY RIGHTS HELD IN THE LICENSED WORK BY THE LICENSOR. THE LICENSOR MAKES NO
    REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR
    OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES OF TITLE, MARKETABILITY, MERCHANTIBILITY,
    FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY,
    OR THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE
    EXCLUSION OF IMPLIED WARRANTIES, SO SUCH EXCLUSION MAY NOT APPLY TO YOU.
*/

/*
    library
*/

local base                  = rlib
local helper                = base.h
local design                = base.d
local ui                    = base.i

/*
    localization > misc
*/

local cfg                   = base.settings
local mf                    = base.manifest

/*
    PANEL
*/

local PANEL = { }

AccessorFunc( PANEL, 'm_bDoSort', 'SortItems', FORCE_BOOL )

/*
    Init
*/

function PANEL:Init( )
	self.DropButton = vgui.Create( 'DPanel', self )
	self.DropButton.Paint = function( panel, w, h ) derma.SkinHook( 'Paint', 'ComboDownArrow', panel, w, h ) end
	self.DropButton:SetMouseInputEnabled( false )
	self.DropButton.ComboBox = self

	self:SetTall( 22 )
	self:Clear( )

	self:SetContentAlignment    ( 4 )
	self:SetTextInset           ( 8, 0 )
	self:SetIsMenu              ( true )
	self:SetSortItems           ( true )
end

/*
    clear
*/

function PANEL:Clear( )
	self:SetText        ( '' )
	self.Choices        = { }
	self.Data           = { }
	self.ChoiceIcons    = { }
	self.Spacers        = { }
	self.selected       = nil

	if ( self.Menu ) then
		self.Menu:Remove( )
		self.Menu = nil
	end
end

/*
    option text > get
*/

function PANEL:GetOptionText( id )
	return self.Choices[ id ]
end

/*
    option data > get
*/

function PANEL:GetOptionData( id )
	return self.Data[ id ]
end

/*
    option text > get by data
*/

function PANEL:GetOptionTextByData( data )
	for id, dat in pairs( self.Data ) do
		if ( dat == data ) then
			return self:GetOptionText( id )
		end
	end

	-- Try interpreting it as a number
	for id, dat in pairs( self.Data ) do
		if ( dat == tonumber( data ) ) then
			return self:GetOptionText( id )
		end
	end

	-- In case we fail
	return data
end

/*
    perform layout
*/

function PANEL:PerformLayout( )
	self.DropButton:SetSize( 20, 20 )
	self.DropButton:AlignRight( 4 )
	self.DropButton:CenterVertical( )
	DButton.PerformLayout = function ( s, w, h )

    end
end

/*
    option > choose
*/

function PANEL:ChooseOption( value, index )
	if ( self.Menu ) then
		self.Menu:Remove( )
		self.Menu = nil
	end

	self:SetText( value )

	-- This should really be the here, but it is too late now and convar changes are handled differently by different child elements
	--self:ConVarChanged( self.Data[ index ] )

	self.selected = index
	self:OnSelect( index, value, self.Data[ index ] )
end

/*
    option > choose id
*/

function PANEL:ChooseOptionID( index )
	local value = self:GetOptionText( index )
	self:ChooseOption( value, index )
end

/*
    option > get selected by id
*/

function PANEL:GetSelectedID( )
	return self.selected
end

/*
    option > get selected
*/

function PANEL:GetSelected( )
	if ( !self.selected ) then return end
	return self:GetOptionText( self.selected ), self:GetOptionData( self.selected )
end

/*
    on select
*/

function PANEL:OnSelect( index, value, data )
	-- For override
end

/*
    on menu opened
*/

function PANEL:OnMenuOpened( menu )
	-- For override
end

/*
    add spacer
*/

function PANEL:AddSpacer( )
	self.Spacers[ #self.Choices ] = true
end

/*
    choice > add
*/

function PANEL:AddChoice( value, data, select, icon )
	local i = table.insert( self.Choices, value )

	if ( data ) then
		self.Data[ i ] = data
	end

	if ( icon ) then
		self.ChoiceIcons[ i ] = icon
	end

	if ( select ) then
		self:ChooseOption( value, i )
	end

	return i
end

/*
    menu > is opened
*/

function PANEL:IsMenuOpen( )
	return IsValid( self.Menu ) && self.Menu:IsVisible( )
end

/*
    menu > open
*/

function PANEL:OpenMenu( pControlOpener )

	if ( pControlOpener && pControlOpener == self.TextEntry ) then
		return
	end

	-- Don't do anything if there aren't any options..
	if ( #self.Choices == 0 ) then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove( )
		self.Menu = nil
	end

	-- If we have a modal parent at some level, we gotta parent to that or our menu items are not gonna be selectable
	local parent = self
	while ( IsValid( parent ) && !parent:IsModal( ) ) do
		parent = parent:GetParent( )
	end
	if ( !IsValid( parent ) ) then parent = self end

	self.Menu = DermaMenu( false, parent )

	if ( self:GetSortItems( ) ) then
		local sorted = { }
		for k, v in pairs( self.Choices ) do
			local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
			if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( '#' ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
			table.insert( sorted, { id = k, data = v, label = val } )
		end
		for k, v in SortedPairsByMemberValue( sorted, 'label' ) do
			local option = self.Menu:AddOption( v.data, function( ) self:ChooseOption( v.data, v.id ) end )
			if ( self.ChoiceIcons[ v.id ] ) then
				option:SetIcon( self.ChoiceIcons[ v.id ] )
			end
			if ( self.Spacers[ v.id ] ) then
				self.Menu:AddSpacer( )
			end
		end
	else
		for k, v in pairs( self.Choices ) do
			local option = self.Menu:AddOption( v, function( ) self:ChooseOption( v, k ) end )
			if ( self.ChoiceIcons[ k ] ) then
				option:SetIcon( self.ChoiceIcons[ k ] )
			end
			if ( self.Spacers[ k ] ) then
				self.Menu:AddSpacer( )
			end
		end
	end

	local x, y = self:LocalToScreen( 0, self:GetTall( ) )

	self.Menu:SetMinimumWidth( self:GetWide( ) )
	self.Menu:Open( x, y, false, self )

	self:OnMenuOpened( self.Menu )

end

/*
    menu > close
*/

function PANEL:CloseMenu( )
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove( )
	end
end

/*
    cvar > changed
*/

function PANEL:CheckConVarChanges( )
	if ( !self.m_strConVar ) then return end

	local strValue = GetConVarString( self.m_strConVar )
	if ( self.m_strConVarValue == strValue ) then return end

	self.m_strConVarValue = strValue

	self:SetValue( self:GetOptionTextByData( self.m_strConVarValue ) )
end

/*
    think
*/

function PANEL:Think( )
	self:CheckConVarChanges( )
end

/*
    value > set
*/

function PANEL:SetValue( strValue )
	self:SetText( strValue )
end

/*
    do click
*/

function PANEL:DoClick( )
	if ( self:IsMenuOpen( ) ) then
		return self:CloseMenu( )
	end

	self:OpenMenu( )
end

/*
    option height > set
*/

function PANEL:SetOptionHeight( i )
    self.btn_height = i
end

/*
    option height > get
*/

function PANEL:GetOptionHeight( )
    return self.btn_height or 22
end

/*
    example
*/

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )
	local ctrl              = vgui.Create( ClassName )
	ctrl:AddChoice          ( 'Some Choice' )
	ctrl:AddChoice          ( 'Another Choice', 'myData' )
	ctrl:AddChoice          ( 'Default Choice', 'myData2', true )
	ctrl:AddChoice          ( 'Icon Choice', 'myData3', false, 'icon16/star.png' )
	ctrl:SetWide            ( 150 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )
end

/*
    Declarations
*/

function PANEL:Declarations( )

    self.bInitialized       = false

    /*
        declare > colors
    */

    self.clr_main_n         = Color( 255, 255, 255, 5 )
    self.clr_main_h         = Color( 255, 255, 255, 9 )
    self.clr_togg_n         = Color( 214, 103, 144 )
    self.clr_togg_e         = Color( 103, 136, 214 )
    self.clr_togg_h         = Color( 255, 255, 255, 30 )
end

/*
    register
*/

derma.DefineControl( 'rlib.ui.cbo', 'rlib combo box', PANEL, 'DButton' )
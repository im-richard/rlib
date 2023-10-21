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
    prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
    X
*/

local X = { }

AccessorFunc( X, 'm_bDoSort', 'SortItems', FORCE_BOOL )

/*
    Init
*/

function X:Init( )

    self 							= ui.get( self                          )
    :setup 							(                                       )

    self.DropButton 				= vgui.Create( 'DPanel', self )
    self.DropButton.Paint 			= function( panel, w, h ) derma.SkinHook( 'Paint', 'ComboDownArrow', panel, w, h ) end
    self.DropButton:SetMouseInputEnabled( false )
    self.DropButton.ComboBox 		= self

    self:Clear( )

    self:SetContentAlignment    	( 4 )
    self:SetTextInset           	( 8, 0 )
    self:SetIsMenu              	( true )
    self:SetSortItems           	( true )
end

/*
    clear
*/

function X:Clear( )
    self:SetText            ( '' )
    self.Choices            = { }
    self.Data               = { }
    self.ChoiceIcons        = { }
    self.Spacers            = { }
    self.selected           = nil

    if ( self.Menu ) then
        self.Menu:Remove( )
        self.Menu = nil
    end
end

/*
    option text > get
*/

function X:GetOptionText( id )
    return self.Choices[ id ]
end

/*
    option data > get
*/

function X:GetOptionData( id )
    return self.Data[ id ]
end

/*
    option text > get by data
*/

function X:GetOptionTextByData( data )
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

function X:PerformLayout( )
    self.DropButton:SetSize( 20, 20 )
    self.DropButton:AlignRight( 4 )
    self.DropButton:CenterVertical( )
    DButton.PerformLayout = function ( s, w, h )

    end
end

/*
    option > choose
*/

function X:ChooseOption( value, index )
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

function X:ChooseOptionID( index )
    local value = self:GetOptionText( index )
    self:ChooseOption( value, index )
end

/*
    option > get selected by id
*/

function X:GetSelectedID( )
    return self.selected
end

/*
    option > get selected
*/

function X:GetSelected( )
    if ( !self.selected ) then return end
    return self:GetOptionText( self.selected ), self:GetOptionData( self.selected )
end

/*
    on select
*/

function X:OnSelect( index, value, data )
    local def               = self:GetDefault( )
                            if not def then return end

    data                    = data ~= nil and data or def
    local cv                = GetConVar( self.cvar )

    cv:SetString            ( data )
end

/*
    on menu opened
*/

function X:OnMenuOpened( menu )
    -- For override
end

/*
    add spacer
*/

function X:AddSpacer( )
    self.Spacers[ #self.Choices ] = true
end

/*
    convar > set

    @param  :   str             id
*/

function X:SetConvar( id )
    if not id then return end
    self.cvar = id
end

/*
    convar > get

    @return :   bool
*/

function X:GetConvar( )
    return self.cvar
end

/*
    default > set

    @param      :   str         id
*/

function X:SetDefault( id )
    if not id then return end
    self.def = id
end

/*
    default > get

    @return     :   str
*/

function X:GetDefault( )
    return self.def
end

/*
    choice > add
*/

function X:AddChoice( value, data, select, icon )
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

function X:IsMenuOpen( )
    return IsValid( self.Menu ) && self.Menu:IsVisible( )
end

/*
    add item

    @param      :   tbl         v
    @param      :   int         k
*/

function X:AddItem( v, k )

    local i_max 					= table.Count( v )
    local t                         = k == 1 and 0 or 0
    local b                         = k == i_max and 0 or 0
    local sz_dot                    = 5
    local clr_dot                   = self:GetCatColors( k )
    clr_dot                         = rclr.Hex( clr_dot )

    local cbo_cat                   = ui.obj( 'cbo'                         )
    :cbosetup                       (                                       )
    :top                            ( 0, 0, 0, 0                            )
    :tall                           ( 40 * rfs.h( )                         )

                                    :draw( function( s, w, h )
                                        if ( k % 2 == 0 ) then
                                            design.box( 0, t, w - 0, h - b, self.clr_line_1 )
                                        else
                                            design.box( 0, t, w - 0, h - b, self.clr_line_2 )
                                        end

                                        if s.hover then
                                            local pulse     = math.abs( math.sin( CurTime( ) * 5 ) * 255 )
                                            pulse           = math.Clamp( pulse, 50, 200 )

                                            design.box( 0, 0, w - 0, h - b, ColorAlpha( self.clr_line_h, pulse ) )
                                        end

                                        design.circle( 17, ( h / 2 ) + ( sz_dot / 2 ) - ( sz_dot / 2 ), sz_dot, 25, clr_dot )

                                        draw.SimpleText( v.data, pid( 'ucl_ddl_item' ), 35, h / 2, self.clr_txt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

                                    :pl( function( s )
                                        s.DropButton:SetSize( 0, 0 )
                                    end )

                                    :oc( function( s )
                                        self:ChooseOption( v.data, v.id )
                                        ui:destroy( self.Menu )
                                    end )

    /*
        add item
    */

    self.Menu:AddPanel              ( cbo_cat )
    cbo_cat:AddChoice               ( id, name )

end

/*
    menu > open
*/

function X:OpenMenu( pControlOpener )

    if ( pControlOpener && pControlOpener == self.TextEntry ) then return end

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

    local asdasd = self:GetSortItems( )

    if ( self:GetSortItems( ) ) then

        local sorted = { }
        for k, v in pairs( self.Choices ) do
            local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
            if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( '#' ) ) then val = language.GetPhrase( val:sub( 2 ) ) end

            table.insert( sorted, { id = k, data = v, label = val } )
        end

        local i_lst = 1
        for k, v in helper.get.sorted_k( sorted, 4, 'label' ) do
            self:AddItem( v, i_lst )
            i_lst = i_lst + 1
        end

    else

        for k, v in pairs( self.Choices ) do
            local option = self.Menu:AddOption( v, function( )
                self:ChooseOption( v, k )
            end )

            if ( self.ChoiceIcons[ k ] ) then
                option:SetIcon( self.ChoiceIcons[ k ] )
            end

            if ( self.Spacers[ k ] ) then
                self.Menu:AddSpacer( )
            end
        end

    end

    local x, y                      = self:LocalToScreen( 0, self:GetTall( ) )
    self.Menu:SetMinimumWidth       ( self:GetWide( ) )
    self.Menu:Open                  ( x, y, false, self )

    self.Menu                       = ui.get( self.Menu )
    :keeptop                        ( )

    self:OnMenuOpened               ( self.Menu )

end

/*
    categories > colors

    @param      :   int         i
    @return     :   str
*/

function X:GetCatColors( i )

    local clrs =
    {
        'c04178', '2a5985', 'fe0000', '7cab4d',
        'edcb34', '12a39e', '79d2be', 'a1a0a5',
        'cb473b', 'af313d', '674b74', '7e6ca8',
        'b16646', 'b1d1ea', 'd99d22', 'e16a63',
        'ff7e3c', 'b0d2d4', '377a93', '4e807f',
        'fdb8bd', 'e88297', 'c31922', 'b91135',
        'f0245e', '9e32af', '0099f3', '88c047',
        'ff5606', '0081c3', 'c84063', '981d22',
        'f7a81b', 'f47521', 'f2e6b1', 'cc0085',
    }

    return clrs[ i ] or table.Random( clrs )

end

/*
    menu > close
*/

function X:CloseMenu( )
    if ( IsValid( self.Menu ) ) then
        self.Menu:Remove( )
    end
end

/*
    cvar > changed
*/

function X:CheckConVarChanges( )
    if ( !self.m_strConVar ) then return end

    local strValue = GetConVarString( self.m_strConVar )
    if ( self.m_strConVarValue == strValue ) then return end

    self.m_strConVarValue = strValue

    self:SetValue( self:GetOptionTextByData( self.m_strConVarValue ) )
end

/*
    think
*/

function X:Think( )
    self:CheckConVarChanges( )
end

/*
    value > set
*/

function X:SetValue( str )
    self:SetText( str )
end

/*
    do click
*/

function X:DoClick( )
    if ( self:IsMenuOpen( ) ) then
        return self:CloseMenu( )
    end

    self:OpenMenu( )
end

/*
    option height > set

    @note       : deprecate
*/

function X:SetOptionHeight( i )
    self.btn_height = i
end

/*
    option height > get

    @note       : deprecate
*/

function X:GetOptionHeight( )
    return self.btn_height or 22
end

/*
    colorize
*/

function X:_Colorize( )

    /*
        declare > colors
    */

    self.clr_txt                    = rclr.Hex( 'FFFFFF' )
    self.clr_main_n         		= rclr.Hex( 'FFFFFF', 5 )
    self.clr_main_h         		= rclr.Hex( 'FFFFFF', 9 )
    self.clr_togg_n         		= rclr.Hex( 'd66790' )
    self.clr_togg_e         		= rclr.Hex( '6788d6' )
    self.clr_togg_h         		= rclr.Hex( 'FFFFFF', 30 )
    self.clr_line_1                 = rclr.Hex( '161616', 255 )
    self.clr_line_2                 = rclr.Hex( '121212', 255 )
    self.clr_line_h                 = rclr.Hex( '282828' )
end

/*
    register
*/

derma.DefineControl( 'rlib.ui.cbo', 'rlib combo box', X, 'DButton' )
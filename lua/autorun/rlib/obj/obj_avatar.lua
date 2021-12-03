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
*   localization > misc
*/

local cfg                   = base.settings
local mf                    = base.manifest

/*
*   localization
*/

local cos, sin, rad, render, draw = math.cos, math.sin, math.rad, render, draw

/*
*   PANEL
*/

local PANEL = { }

/*
*   Init
*/

function PANEL:Init( )

    /*
    *   animated dmodel pnl
    */

    self.avatar_anim = vgui.Create( 'DModelPanel', self )
    self.avatar_anim:SetModel( LocalPlayer( ):GetModel( ) )
    self.avatar_anim:SetPos( 5, 5 )
    self.avatar_anim:SetSize( 64, 64 )
    self.avatar_anim:SetVisible( false )
    self.avatar_anim.Think = function( s )
        local pl = LocalPlayer( )
        s:SetModel( pl:GetModel( ) )

        local getgroup, getskin = '', pl:GetSkin( ) or 0
        for n = 0, pl:GetNumBodyGroups( ) do
            getgroup = getgroup .. pl:GetBodygroup( n )
        end

        s.Entity:SetBodyGroups( getgroup )
        s.Entity:SetSkin( getskin )
    end
    self.avatar_anim.LayoutEntity = function( ent ) return end
    self.avatar_anim.Entity.GetPlayerColor = function( ) return LocalPlayer( ):GetPlayerColor( ) end
    self.avatar_anim.Entity.GetSkin = function( ) return LocalPlayer( ):GetSkin( ) end
    self.avatar_anim:SetPaintedManually( true )

    /*
    *   player avatar pnl
    */

    self.avatar = vgui.Create( 'AvatarImage', self )
    self.avatar:SetPaintedManually( true )
    self.avatar:SetVisible( false )

    self.avatar_sz = 36
    self.CircleMask = { }

end

/*
*   Think
*/

function PANEL:Think( )
    if self.bUseAnim then
        self.avatar_anim:SetVisible     ( true )
        self.avatar_anim:SetFOV         ( self:GetAnimFOV( ) )
        self.avatar_anim:SetCamPos      ( self:GetAnimCamPos( ) )
        self.avatar_anim:SetLookAt      ( self:GetAnimLookPos( ) )
        self.avatar:SetVisible          ( false )
    else
        self.avatar:SetVisible          ( true )
        self.avatar_anim:SetVisible     ( false )
    end
end

/*
*   PerformLayout
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:PerformLayout( w, h )
    local radian, sz_multiple = 0, 0.4

    self.avatar_anim:SetSize( w, h )
    self.avatar:SetSize( w, h )

    self.avatar_sz = w * sz_multiple

    for i = 1, 360 do
        radian                  = rad( i )
        self.CircleMask[ i ]    = { x = w / 2 + cos( radian ) * self.avatar_sz, y = h / 2 + sin( radian ) * self.avatar_sz }
    end
end

/*
*   SetPlayer
*
*   @param  : ply pl
*/

function PANEL:SetPlayer( pl )
    self.avatar_anim:SetPlayer  ( pl or LocalPlayer( ), self:GetWide( ) )
    self.avatar:SetPlayer       ( pl or LocalPlayer( ), self:GetWide( ) )
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    if self.bUseAnim then
        self.avatar_anim:SetPaintedManually     ( false         )
        self.avatar_anim:PaintManual            (               )
        self.avatar_anim:SetPaintedManually     ( true          )
        return
    end

    if not self.bUseRounded then
        self.avatar:SetPaintedManually          ( false         )
        self.avatar:PaintManual                 (               )
        self.avatar:SetPaintedManually          ( true          )
        return
    end

    design.StencilStart( )

    draw.NoTexture( )
    surface.SetDrawColor( color_white )
    surface.DrawPoly( self.CircleMask )

    design.StencilReplace( )

    self.avatar:SetPaintedManually( false )
    self.avatar:PaintManual( )
    self.avatar:SetPaintedManually( true )

    design.StencilEnd( )
end

/*
*   SetRounded
*
*   determines if the rounding stencil will be used for a more modern look.
*   causes glitches with dmodel so future tweaks will need to be done (only affects certain models)
*
*   @param  : bool bValue
*/

function PANEL:SetRounded( bValue )
    self.bUseRounded = bValue or false
end

/*
*   GetbUseRounded
*/

function PANEL:GetRounded( )
    return self.bUseRounded
end

/*
*   SetbUseAnim
*
*   determines if the player avatar or player model will be used
*
*   @param  : bool bValue
*/

function PANEL:SetbUseAnim( bValue )
    self.bUseAnim = bValue or false
end

/*
*   GetbUseAnim
*/

function PANEL:GetbUseAnim( )
    return self.bUseAnim
end

/*
*   SetAnimFOV
*
*   sets the field of view if player model (dmodel) used
*
*   @param  : int int
*/

function PANEL:SetAnimFOV( int )
    self.anim_fov = isnumber( int ) and int or 12
end

/*
*   GetbUseAnim
*/

function PANEL:GetAnimFOV( )
    return self.anim_fov or 12
end

/*
*   SetAnimCamPos
*
*   sets campos if player model (dmodel) used
*
*   @param  : vec vec
*/

function PANEL:SetAnimCamPos( vec )
    self.anim_campos = isvector( vec ) and vec
end

/*
*   GetbUseAnim
*/

function PANEL:GetAnimCamPos( )
    return self.anim_campos or Vector( 85, -11, 65 )
end

/*
*   SetAnimLookPos
*
*   sets lookat pos if player model (dmodel) used
*
*   @param  : vec vec
*/

function PANEL:SetAnimLookPos( vec )
    self.anim_lookpos = isvector( vec ) and vec
end

/*
*   GetbUseAnim
*/

function PANEL:GetAnimLookPos( )
    return self.anim_lookpos or Vector( -2, 1, 63 )
end

/*
*   DefineControl
*/

derma.DefineControl( 'rlib.ui.avatar', 'rlib avatar', PANEL, 'EditablePanel' )
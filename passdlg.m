function passdlg(uitype)

% Parse UI type
[hasUsernameField, hasConfirmPassword, hasShowCheckBox] = getUItype(uitype);
offset = (hasUsernameField + hasConfirmPassword)*50 + hasShowCheckBox*30;

% Figure
fh = figure('DockControls'  , 'off',...
    'IntegerHandle' , 'off',...
    'InvertHardcopy', 'off',...
    'MenuBar'       , 'none',...
    'NumberTitle'   , 'off',...
    'Resize'        , 'off',...
    'Visible'       , 'on',...
    'WindowStyle'   , 'normal',...
    'Name'          , 'Password',...
    'Position'      , [0, 0, 175 83.6 + offset]);

% Axes (for text labels)
ah = axes('Parent',fh,'Position',[0 0 1 1],'Visible','off');

% Get some default properties
defaults = getDefaults;

% Username field and label
if hasUsernameField
    h.edituser = uicontrol(fh, ...
        defaults.EdInfo      , ...
        'Max'       ,1, ...
        'Position'  ,[5, 36.6 + offset, 165, 23]);
    h.labeluser = text('Parent',ah, ...
        defaults.TextInfo     , ...
        'Position'   ,[5 59.6 + offset], ...
        'String'     ,'Username'  , ...
        'Interpreter','none');
end

offset = offset - hasUsernameField*50;
% Password field
h.editpass = passfield('Parent',fh,...
    'Position'       , [5, 36.6 + offset, 165, 23],...
    'BackgroundColor', [1,1,1]);
% Password label
h.labelpass = text('Parent',ah, ...
    defaults.TextInfo,...
    'Position'   ,[5 59.6 + offset]      , ...
    'String'     , 'Password'   , ...
    'Interpreter','none');

% Confirm password
if hasConfirmPassword
    offset = offset - 50;
    h.editpassconf = passfield('Parent',fh,...
        'Position'       , [5, 36.6 + offset, 165, 23],...
        'BackgroundColor', [1,1,1]);
    h.labelpassconf = text('Parent',ah, ...
        defaults.TextInfo,...
        'Position'   ,[5 59.6 + offset]      , ...
        'String'     , 'Confirm password'   , ...
        'Interpreter','none');
end

% Show/hide password checkbox
if hasShowCheckBox
    offset = offset - 30;
    h.cbshow = uicontrol(fh, ...
        defaults.CbInfo,...
        'Position',[5, 36.6 + offset, 165, 23],...
        'String'  , 'Show password',...
        'Callback', {@clb_showpass,h});
end

% OK button
h.btnok = uicontrol(fh,...
  defaults.BtnInfo      , ...
  'Position'   ,[59, 5, 53, 26.6] , ...
  'KeyPressFcn',@doControlKeyPress , ...
  'String'     ,'OK',...
  'Callback'   ,@doCallback);

% Cancel button
h.btncancel = uicontrol(fh,...
  defaults.BtnInfo      , ...
  'Position'   ,[117 5 53 26.6],...
  'KeyPressFcn',@doControlKeyPress,...
  'String'     ,'Cancel',...
  'Callback'   ,@doCallback);

fh.setDefaultButton(h.btnok);

% set(InputFig,'ResizeFcn', {@doResize, inputWidthSpecified});

% make sure we are on screen
movegui(fh,'center')

end

function [u, c, s] = getUItype(type)
ucs = false(3,1);
if iscellstr(type)
    validoptions = {'UsernameField','ConfirmPass','ShowHideCheckBox'};
    for ii = 1:numel(type)
        n = numel(type{ii});
        tmp = strncmpi(type{ii}, validoptions, n);
        if ~all(tmp)
            warning('passdlg:unrecognizeType','Unrecognized option ''%s''.',type{ii})
            continue
        end
        ucs = ucs | tmp;
        if all(ucs), break, end
    end
elseif ischar(type) && isrow(type)
    ucs = any(bsxfun(@eq, 'ucs',type'));
end
u = ucs(1);
c = ucs(2);
s = ucs(3);
end

function s = getDefaults
s.FigColor = get(0,'DefaultUicontrolBackgroundColor');
s.TextInfo = struct('Units', 'pixels',...
    'FontSize'             , 8,...
    'FontWeight'           , 'normal',...
    'HorizontalAlignment'  ,'left',...
    'HandleVisibility'     ,'callback',...
    'VerticalAlignment'    , 'bottom',...
    'BackgroundColor'      ,s.FigColor);
s.BtnInfo = struct('Units', 'pixels',...
                 'FontSize', 8,...
                 'FontWeight', 'normal',...
                 'HorizontalAlignment'  ,'center',...
                 'HandleVisibility'     ,'callback',...
                 'Style'                ,'pushbutton',...
                 'BackgroundColor'      , s.FigColor);

s.EdInfo = struct('Units', 'pixels',...
                 'FontSize', 8,...
                 'FontWeight', 'normal',...
                 'HorizontalAlignment'  ,'left',...
                 'HandleVisibility'     ,'callback',...
                 'Style'                ,'edit',...
                 'BackgroundColor'      ,[1,1,1]);
s.CbInfo = struct('Units', 'pixels',...
                 'FontSize', 8,...
                 'FontWeight', 'normal',...
                 'HorizontalAlignment'  ,'left',...
                 'HandleVisibility'     ,'callback',...
                 'Style'                ,'checkbox');
end
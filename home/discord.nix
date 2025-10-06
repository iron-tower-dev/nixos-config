{ config, pkgs, lib, ... }:

{
  # Discord with custom theming
  home.packages = with pkgs; [
    # Discord with OpenAsar for better performance and theming
    (discord.override {
      withOpenASAR = true;
      withVencord = true;  # Vencord for additional customization
    })
  ];
  
  # Create Discord configuration directory and custom CSS
  xdg.configFile."discord/settings.json".text = builtins.toJSON {
    BACKGROUND_COLOR = "#${config.lib.stylix.colors.base00}";
    SKIP_HOST_UPDATE = true;
    IS_MAXIMIZED = false;
    IS_MINIMIZED = false;
    WINDOW_BOUNDS = {
      x = 100;
      y = 100;
      width = 1280;
      height = 720;
    };
  };
  
  # Vencord configuration for Stylix-based theming
  xdg.configFile."Vencord/settings/quickCss.css".text = ''
    /**
     * Discord Custom CSS - Stylix Theme
     * Auto-generated from system colors
     */
    
    :root {
      /* Base colors from Stylix */
      --background-primary: #${config.lib.stylix.colors.base00};
      --background-secondary: #${config.lib.stylix.colors.base01};
      --background-secondary-alt: #${config.lib.stylix.colors.base02};
      --background-tertiary: #${config.lib.stylix.colors.base01};
      --background-accent: #${config.lib.stylix.colors.base03};
      --background-floating: #${config.lib.stylix.colors.base00};
      --background-mobile-primary: #${config.lib.stylix.colors.base00};
      --background-mobile-secondary: #${config.lib.stylix.colors.base01};
      --background-modifier-hover: rgba(${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b}, 0.16);
      --background-modifier-active: rgba(${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b}, 0.24);
      --background-modifier-selected: rgba(${config.lib.stylix.colors.base0D-rgb-r}, ${config.lib.stylix.colors.base0D-rgb-g}, ${config.lib.stylix.colors.base0D-rgb-b}, 0.32);
      --background-modifier-accent: rgba(${config.lib.stylix.colors.base03-rgb-r}, ${config.lib.stylix.colors.base03-rgb-g}, ${config.lib.stylix.colors.base03-rgb-b}, 0.48);
      
      /* Text colors */
      --text-normal: #${config.lib.stylix.colors.base05};
      --text-muted: #${config.lib.stylix.colors.base04};
      --text-link: #${config.lib.stylix.colors.base0D};
      --text-positive: #${config.lib.stylix.colors.base0B};
      --text-warning: #${config.lib.stylix.colors.base0A};
      --text-danger: #${config.lib.stylix.colors.base08};
      --text-brand: #${config.lib.stylix.colors.base0E};
      
      /* Interactive colors */
      --interactive-normal: #${config.lib.stylix.colors.base05};
      --interactive-hover: #${config.lib.stylix.colors.base0D};
      --interactive-active: #${config.lib.stylix.colors.base0C};
      --interactive-muted: #${config.lib.stylix.colors.base03};
      
      /* Channel colors */
      --channels-default: #${config.lib.stylix.colors.base05};
      --channel-icon: #${config.lib.stylix.colors.base04};
      
      /* Header colors */
      --header-primary: #${config.lib.stylix.colors.base05};
      --header-secondary: #${config.lib.stylix.colors.base04};
      
      /* Scrollbar */
      --scrollbar-thin-thumb: #${config.lib.stylix.colors.base03};
      --scrollbar-thin-track: transparent;
      --scrollbar-auto-thumb: #${config.lib.stylix.colors.base03};
      --scrollbar-auto-track: #${config.lib.stylix.colors.base01};
      
      /* Elevation/shadows */
      --elevation-stroke: 0 0 0 1px rgba(${config.lib.stylix.colors.base03-rgb-r}, ${config.lib.stylix.colors.base03-rgb-g}, ${config.lib.stylix.colors.base03-rgb-b}, 0.15);
      --elevation-low: 0 1px 0 rgba(${config.lib.stylix.colors.base03-rgb-r}, ${config.lib.stylix.colors.base03-rgb-g}, ${config.lib.stylix.colors.base03-rgb-b}, 0.2);
      --elevation-medium: 0 4px 4px rgba(0, 0, 0, 0.16);
      --elevation-high: 0 8px 16px rgba(0, 0, 0, 0.24);
      
      /* Brand colors */
      --brand-experiment: #${config.lib.stylix.colors.base0D};
      --brand-experiment-100: #${config.lib.stylix.colors.base0D};
      --brand-experiment-200: #${config.lib.stylix.colors.base0D};
      --brand-experiment-300: #${config.lib.stylix.colors.base0D};
      --brand-experiment-360: #${config.lib.stylix.colors.base0D};
      --brand-experiment-400: #${config.lib.stylix.colors.base0D};
      --brand-experiment-430: #${config.lib.stylix.colors.base0D};
      --brand-experiment-460: #${config.lib.stylix.colors.base0D};
      --brand-experiment-500: #${config.lib.stylix.colors.base0D};
      --brand-experiment-530: #${config.lib.stylix.colors.base0D};
      --brand-experiment-560: #${config.lib.stylix.colors.base0D};
      --brand-experiment-600: #${config.lib.stylix.colors.base0D};
      --brand-experiment-630: #${config.lib.stylix.colors.base0D};
      --brand-experiment-660: #${config.lib.stylix.colors.base0D};
      --brand-experiment-700: #${config.lib.stylix.colors.base0D};
      --brand-experiment-730: #${config.lib.stylix.colors.base0D};
      --brand-experiment-760: #${config.lib.stylix.colors.base0D};
      --brand-experiment-800: #${config.lib.stylix.colors.base0D};
      --brand-experiment-830: #${config.lib.stylix.colors.base0D};
      --brand-experiment-860: #${config.lib.stylix.colors.base0D};
      --brand-experiment-900: #${config.lib.stylix.colors.base0D};
    }
    
    /* Smooth transitions */
    * {
      transition: background-color 0.2s ease, color 0.2s ease, border-color 0.2s ease;
    }
    
    /* Rounded corners for modern look */
    .wrapper-1HIH0j,
    .container-1NXEtd,
    .panels-3wFtMD,
    .container-2cd8Mz,
    .peopleColumn-1wMU14 {
      border-radius: 12px;
    }
    
    /* Message input styling */
    .channelTextArea-1FufC0 {
      border-radius: 8px;
      background-color: var(--background-secondary);
    }
    
    /* Server/channel list improvements */
    .sidebar-1tnWFu {
      background-color: var(--background-primary);
    }
    
    .container-1NXEtd {
      background-color: var(--background-secondary);
    }
    
    /* Better message styling */
    .message-2CShn3 {
      border-radius: 4px;
      padding: 8px;
      margin: 2px 0;
    }
    
    .message-2CShn3:hover {
      background-color: var(--background-modifier-hover);
    }
    
    /* Smooth scrollbar */
    ::-webkit-scrollbar {
      width: 8px;
    }
    
    ::-webkit-scrollbar-track {
      background: var(--scrollbar-auto-track);
    }
    
    ::-webkit-scrollbar-thumb {
      background: var(--scrollbar-auto-thumb);
      border-radius: 4px;
    }
    
    ::-webkit-scrollbar-thumb:hover {
      background: var(--interactive-hover);
    }
    
    /* Enhanced buttons */
    .button-f2h6uQ {
      border-radius: 6px;
      transition: all 0.2s ease;
    }
    
    .button-f2h6uQ:hover {
      transform: translateY(-1px);
      box-shadow: var(--elevation-medium);
    }
    
    /* User popout improvements */
    .userPopout-2j1gM4 {
      border-radius: 12px;
      overflow: hidden;
    }
    
    /* Status indicators */
    .status-1p05lz {
      border: 2px solid var(--background-primary);
    }
    
    /* Code blocks */
    code {
      background-color: var(--background-secondary-alt);
      border-radius: 4px;
      padding: 2px 4px;
    }
    
    .hljs {
      background-color: var(--background-secondary-alt);
      border-radius: 8px;
    }
  '';
  
  # Vencord settings
  xdg.configFile."Vencord/settings/settings.json".text = builtins.toJSON {
    notifyAboutUpdates = true;
    autoUpdate = false;
    autoUpdateNotification = true;
    useQuickCss = true;
    themeLinks = [];
    enabledThemes = [];
    enableReactDevtools = false;
    frameless = false;
    transparent = false;
    winCtrlQ = false;
    disableMinSize = false;
    winNativeTitleBar = false;
    plugins = {
      BadgeAPI = { enabled = true; };
      CommandsAPI = { enabled = true; };
      ContextMenuAPI = { enabled = true; };
      MemberListDecoratorsAPI = { enabled = true; };
      MessageAccessoriesAPI = { enabled = true; };
      MessageDecorationsAPI = { enabled = true; };
      MessageEventsAPI = { enabled = true; };
      MessagePopoverAPI = { enabled = true; };
      NoticesAPI = { enabled = true; };
      ServerListAPI = { enabled = true; };
      BetterFolders = { enabled = true; };
      BetterGifAltText = { enabled = true; };
      BetterNotesBox = { enabled = true; };
      BetterRoleDot = { enabled = true; };
      BetterUploadButton = { enabled = true; };
      ClearURLs = { enabled = true; };
      ClientTheme = { enabled = true; };
      ColorSighted = { enabled = true; };
      FavoriteGifSearch = { enabled = true; };
      FixCodeblockGap = { enabled = true; };
      FixSpotifyEmbeds = { enabled = true; };
      ForceOwnerCrown = { enabled = true; };
      GameActivityToggle = { enabled = true; };
      ImageZoom = { enabled = true; };
      MessageLinkEmbeds = { enabled = true; };
      MoreUserTags = { enabled = true; };
      MuteNewGuild = { enabled = true; };
      NoBlockedMessages = { enabled = false; };
      NoDevtoolsWarning = { enabled = true; };
      NoF1 = { enabled = true; };
      NoMosaic = { enabled = true; };
      NoProfileThemes = { enabled = false; };
      NoReplyMention = { enabled = true; };
      NoScreensharePreview = { enabled = false; };
      NoSystemBadge = { enabled = true; };
      NoTypingAnimation = { enabled = false; };
      NoUnblockToJump = { enabled = true; };
      PermissionsViewer = { enabled = true; };
      PictureInPicture = { enabled = true; };
      PinDMs = { enabled = true; };
      PlainFolderIcon = { enabled = true; };
      QuickReply = { enabled = true; };
      ReactErrorDecoder = { enabled = true; };
      ReadAllNotificationsButton = { enabled = true; };
      RelationshipNotifier = { enabled = true; };
      RevealAllSpoilers = { enabled = false; };
      ReverseImageSearch = { enabled = true; };
      SearchReply = { enabled = true; };
      SendTimestamps = { enabled = true; };
      ServerProfile = { enabled = true; };
      ShowAllMessageButtons = { enabled = true; };
      ShowConnections = { enabled = true; };
      ShowHiddenChannels = { enabled = true; };
      ShowMeYourName = { enabled = true; };
      SilentMessageToggle = { enabled = true; };
      SilentTyping = { enabled = true; };
      SortFriendRequests = { enabled = true; };
      SpotifyControls = { enabled = true; };
      SpotifyCrack = { enabled = true; };
      StartupTimings = { enabled = false; };
      SupportHelper = { enabled = true; };
      TimeBarAllActivities = { enabled = true; };
      Translate = { enabled = true; };
      TypingIndicator = { enabled = true; };
      TypingTweaks = { enabled = true; };
      Unindent = { enabled = true; };
      UnsuppressEmbeds = { enabled = true; };
      UserVoiceShow = { enabled = true; };
      USRBG = { enabled = true; };
      ValidUser = { enabled = true; };
      VoiceChatDoubleClick = { enabled = true; };
      VoiceMessages = { enabled = true; };
      VolumeBooster = { enabled = true; };
      WhoReacted = { enabled = true; };
    };
  };
}

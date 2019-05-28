function cfg = nfb_getThreshold(cfg)
% This function implements a resting state protocol to get a baseline level
% of the parameters specified by cfg

try
    
    % Clear the workspace and the screen
    sca;
    close all;
    %PsychPortAudio('Close')
    
    %electrodeLoc = input('Enter electrode location (remember to use quotes): ');
    
    % Here we call some default settings for setting up Psychtoolbox
    if ~cfg.debug
        PsychDefaultSetup(2);
        Screen('Preference', 'SkipSyncTests', 1);
    end
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screenNumber = max(screens);
    
    % Define black and white (white will be 1 and black 0). This is because
    % in general luminace values are defined between 0 and 1 with 255 steps in
    % between. All values in Psychtoolbox are defined between 0 and 1
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    
    % Do a simply calculation to calculate the luminance value for grey. This
    % will be half the luminace values for white
    grey = white / 2;
    
    % Open an on screen window using PsychImaging and color it grey.
    if ~cfg.debug
        [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
        
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        
        [xCenter, yCenter] = RectCenter(windowRect);
    else
        screenXpixels = 1000;
        screenYpixels = 500;
    end
    
    KbName('UnifyKeyNames');
    
    % Initialize keys
    spaceKey = KbName('space');
    upKey = KbName('UpArrow');
    downKey = KbName('DownArrow');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    bsKey = KbName('BackSpace');
    
    
    lib = lsl_loadlib();
    
    EEGstream = {};
    
    while isempty(EEGstream)
        EEGstream = lsl_resolve_byprop(lib,'type','EEG');
    end
    
    inlet = lsl_inlet(EEGstream{1});
    
    data = [];
    channel = [];
    
    curTime = GetSecs();
    sessionStart = GetSecs();
    lastChunk = GetSecs();
        
%     for c = 1:length(cfg.params)
%         barpos(c) = screenXpixels*c/(length(cfg.params)+1);
%     end
%     
%     barheight = [0.6*screenYpixels 0.9*screenYpixels];
%     
    data = [];
    chunk = [];
    
    %score = 0;
    
    if ~cfg.debug
        Screen('TextSize', window, 48);
    end
    
    %curThreshold = 1; %curThreshold goes from 0 to length(fbands)-1 (easier with mod)
    lastKey = 0;
    
    sessionRecord = cell(1,length(cfg.params));
    
    session = [];
    starttime = GetSecs();
    while true
        lastChunk = GetSecs();
        
        %getting a chunk from the stream and updating the current epoch
        
        [chunk timeStamps] = inlet.pull_chunk();
        session = [session chunk(cfg.chan,:)];
        
        while isempty(chunk)
            WaitSecs(0.5);
            [chunk timeStamps] = inlet.pull_chunk();
            session = [session chunk(cfg.chan,:)];
        end
        
        data = [data chunk];
        if length(data) > cfg.seglength
            data = data(:,end-cfg.seglength+1:end);
        end
        
        %selecting the right channel (Fz for the moment)
        
        channel = data(cfg.chan,:);
        %session = [session channel];
        
        if cfg.debug
            disp(max(channel) - min(channel))
        end
        
        if isfield(cfg,'transform')
           channel = cfg.transform(channel); 
        end
        
        for c = 1:length(cfg.params)
            passband{c} = ApplyIIRFilt(channel,cfg.params(c).filtcoeffs.b,cfg.params(c).filtcoeffs.a);
            measure(c) = cfg.params(c).func(passband{c});
            sessionRecord{c} = [sessionRecord{c} measure(c)];
        end
        
        if cfg.debug
            msg = [];
            for c = 1:length(cfg.params)
                msg = [msg cfg.params(c).name ': ' num2str(measure(c)) '     '];
            end
            fprintf([msg '\n'])
        else
            DrawFormattedText(window,'+','center','center',white);
%             for c = 1:length(cfg.params)
%                 Screen('FillRect',window,cfg.params(c).colour,[barpos(c)-20,...
%                     barheight(2)-cfg.scaleConst*screenYpixels*measure(c),barpos(c)+20,barheight(2)]);
%                 if ~cfg.observe
%                     if (cfg.params(c).inhibit*cfg.params(c).threshold - measure(c)) > 0
%                         Screen('FillRect',window,[0 1 0],[barpos(c)-30,...
%                             barheight(2)-cfg.scaleConst*cfg.params(c).threshold*screenYpixels,barpos(c)+30,barheight(2)-cfg.scaleConst*cfg.params(c).threshold*screenYpixels+10]);
%                     else
%                         Screen('FillRect',window,[1 0 0],[barpos(c)-30,...
%                             barheight(2)-cfg.scaleConst*cfg.params(c).threshold*screenYpixels,barpos(c)+30,barheight(2)-cfg.scaleConst*cfg.params(c).threshold*screenYpixels+10]);
%                     end
%                 end
%             end
            
%             if ~cfg.observe
%                 %                 if voltage.theta < threshold.theta && voltage.alpha < threshold.alpha && voltage.hibeta < threshold.hibeta
%                 %                     score = score + 1;
%                 %                 end
%                 count = 0;
%                 for c = 1:length(cfg.params)
%                     if (cfg.params(c).inhibit*cfg.params(c).threshold - measure(c)) > 0
%                         count = count+1;
%                     end
%                 end
%                 if count == length(cfg.params)
%                     score = score+1;
%                 end
%             end
%             
%             [keyIsDown,~,keyCode] = KbCheck;
%             
%             if keyIsDown
%                 lastKey = 1;
%                 keyRelease = keyCode;
%             end
%             
%             if ~keyIsDown && lastKey
%                 if keyRelease(upKey)
%                     cfg.params(curThreshold).threshold = cfg.params(curThreshold).threshold*1.02;
%                 elseif keyRelease(downKey)% && cfg.params(c).threshold > 0.05
%                     cfg.params(curThreshold).threshold = cfg.params(curThreshold).threshold*0.98;
%                 elseif keyRelease(rightKey)
%                     curThreshold = mod(curThreshold,length(cfg.params)+1);
%                 elseif keyRelease(leftKey)
%                     curThreshold = curThreshold - 1;
%                     if curThreshold == 0 %fix this so it's done in one line with math
%                         curThreshold = length(cfg.params);
%                     end
%                 end
%                 lastKey = 0;
%             end
            
            Screen('Flip',window);
        end
        
        curTime = GetSecs();
        
        if (curTime-lastChunk) < cfg.updatetime
            WaitSecs(cfg.updatetime-(curTime-lastChunk));
        end
        
        
        [~, ~, keyCode] = KbCheck;
        if keyCode(bsKey) || (curTime - starttime) > cfg.getthresh.tlimit
            sca;
                        cfg = nfb_setThreshold(cfg,sessionRecord);
            cfg.artifactThresh = median(session)+5*mad(session);
            if strcmpi(cfg.getthresh.save,'yes')
                save(['nfb_rest_' cfg.chanloc '_' date '.mat'],'cfg','sessionRecord','session');
            end
            break;
        end
    end
    
    
catch
    sca;
    psychrethrow(psychlasterror);
end

end
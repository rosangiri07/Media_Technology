function varargout = assignmentGUI(varargin)
% ASSIGNMENTGUI MATLAB code for assignmentGUI.fig
%      ASSIGNMENTGUI, by itself, creates a new ASSIGNMENTGUI or raises the existing
%      singleton*.
%
%      H = ASSIGNMENTGUI returns the handle to a new ASSIGNMENTGUI or the handle to
%      the existing singleton*.
%
%      ASSIGNMENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMENTGUI.M with the given input arguments.
%
%      ASSIGNMENTGUI('Property','Value',...) creates a new ASSIGNMENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assignmentGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assignmentGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assignmentGUI

% Last Modified by GUIDE v2.5 15-Jan-2017 17:31:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assignmentGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @assignmentGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%TODO - 
%explain the t=linspace thing in update.

% --- Executes just before assignmentGUI is made visible.
function assignmentGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assignmentGUI (see VARARGIN)

% Choose default command line output for assignmentGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assignmentGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%GLOBAL DECLARATIONS-------------------------------------------------------
global playing1 % Tracks whether track 1 is currently playing.
global trackloaded1 % Tracks whether track 1 is loaded.
global paused1; %Stores whether track 1 is paused.
global data1; %Stores the data for track 1.
playing1 = false; 
trackloaded1 = false;
paused1 = false;
data1 = 0;

global playing2 % Tracks whether track 2 is currently playing.
global trackloaded2 % Tracks whether track 2 is loaded.
global paused2; %Stores whether track 2 is paused.
global data2; %Stores the data for track 2.
playing2 = false;
trackloaded2 = false;
paused2 = false;
data2 = 0;

global sampleRate; %Stores the sample rate to apply to the tracks.
sampleRate = 48000;
global speedChanged;
speedChanged = false;
%END-----------------------------------------------------------------------
function playSound(track) 
%Plays the selected sound file, track identifies which track.
if track == 1
    global sound1;
    global playing1;
    global trackloaded1;
    global paused1;
    if ~playing1 && trackloaded1
        resume(sound1);
        playing1 = true;
        paused1 = false;
    end
elseif track == 2
    global sound2;
    global playing2;
    global trackloaded2;
    global paused2;
    if ~playing2 && trackloaded2
        resume(sound2);
        playing2 = true;
        paused2 = false;
    end
end
    
function pauseSound(track) 
%Pause currenly playing sound, track identifies which track.
if track == 1
    global sound1;
    global playing1;
    global paused1;
    
    playing1 = false;
    paused1 = true;
    pause(sound1);
elseif track == 2
    global sound2;
    global playing2;
    global paused2;
    
    playing2 = false;
    paused2 = true;
    pause(sound2);
end

function stopSound(handles, track) 
%stops the current song and returns it to the start, track identifies which
%track.

if track == 1
    global trackloaded1;
    global sound1;
    global playing1;
    global paused1;
    
    if trackloaded1 %if track1 has been loaded execute code.
        playing1 = false;
        paused1 = false;
        stop(sound1);
        set(handles.slider1, 'VALUE', get(handles.slider1, 'MIN')); %resets the track 1 slider.
        set(handles.sliderText1, 'String', round(handles.slider1.Value, 1)); %resets the track 1 slider label.
    end
elseif track == 2
    global trackloaded2;
    global sound2;
    global playing2;
    global paused2;
    
    if trackloaded2 %if track2 has been loaded execute code.
        playing2 = false;
        paused2 = false;
        stop(sound2);
        set(handles.slider2, 'VALUE', get(handles.slider2, 'MIN')); %resets the track 2 slider.
        set(handles.sliderText2, 'String', round(handles.slider2.Value, 1)); %resets the track 2 slider label.
    end
end

function loadFile(handles, track) 
%opens explorer window and loads selected sound file, track identifies
%which track.
global sampleRate;
global speedChanged;
[fileName,pathName] = uigetfile( ...
{'*.wav;*.mp3',...
'Audio Files (*.wav,*.mp3)'; ...
'*wav', 'WAV Files(*.wav)';...
'*mp3', 'MP3 Files(*.mp3)';},...
'Select an audio file'); %file explorer opens and offers choice of wav, mp3 or both filetypes.

if fileName % if the user loaded a file.
    [snd,FS]=audioread(fullfile(pathName, fileName)); %snd = sample data, FS = sample rate for that data.
    
    if track == 1
        global data1;
        global sound1;
        global playing1;
        playing1 = false;
        global paused1;
        paused1 = false;
        global trackloaded1;
        trackloaded1 = true;
        
         if FS ~= sampleRate %if the sample rate of the track does not match the global sampleRate.
             [P,Q] = rat(sampleRate/FS); %rational approximation of the global sample rate divided by the track's sample rate.
             data1 = resample(snd,P,Q); %using the data returned by the rat() function the track is resampled to use the new sample rate.
         else
             data1 = snd;
         end
        
        sound1 = audioplayer(data1,sampleRate); %sound1 audioplayer object replaced using the resampled data and the global sample rate.
        set(sound1,'TimerFcn',{@timerUpdate,track, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, track, handles}); %set the timer function and the rate it fires, and the stop function.      
        set(handles.invert1,'Value', 0); %sets the invert track 1 checkbox to unchecked.
        updateUI(data1, sampleRate, handles, track); %updates the UI with the loaded track.
    elseif track == 2
        global data2;
        global sound2;
        global playing2;
        playing2 = false;
        global paused2;
        paused2 = false;
        global trackloaded2;
        trackloaded2 = true;
        
        if FS ~= sampleRate %if the sample rate of the track does not match the global sampleRate.
            [P,Q] = rat(sampleRate/FS); %rational approximation of the global sample rate divided by the track's sample rate.
            data2 = resample(snd,P,Q); %using the data returned by the rat() function the track is resampled to use the new sample rate.
        else
             data2 = snd;
         end
        
        sound2 = audioplayer(data2,sampleRate); %sound2 audioplayer object replaced using the resampled data and the global sample rate.
        set(sound2,'TimerFcn',{@timerUpdate,track, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, track, handles});%set the timer function and the rate it fires, and the stop function.       
        set(handles.invert2,'Value', 0); %set the invert track 2 checkbox to unchecked.
        updateUI(data2, sampleRate, handles, track); %updates the UI with the loaded track.
    end
    if(speedChanged) %if the play speed has been changed it is reset back to default.
        resetSpeed(handles);
    end
end

function songEnded(~,~,track, handles) 
% called when a song is paused or finishes, track identifies which track.
%The ~'s are automatically passed the object and event but these variables are unused so they are replaced by ~.
global playing1;
global playing2;

if track == 1
    if playing1 == true %passes if the song finished.
        playing1 = false;
        set(handles.slider1, 'VALUE', get(handles.slider1, 'MIN')); %set slider for track 1 to 0.
        if get(handles.loop1, 'Value') == true %if the loop track 1 checkbox is checked the track is played again.
            playSound(1);
        end
    end
elseif track == 2
    if playing2 == true %passes if the song finished.
        playing2 = false;
        set(handles.slider2, 'VALUE', get(handles.slider2, 'MIN')); %set slider for track 2 to 0;
        if get(handles.loop2, 'value') == true %if the loop track 2 checkbox is checked the track is played again.
            playSound(2);
        end
    end
end

function updateUI(snd, FS, handles, track)
%called when the axis need updating. Passed the track data, the sample rate
%the handles and the track number.

time=round((1/FS)*length(snd),1); %works out the duration of the track in seconds. 
%Works by dividing 1 by the number of samples per second and then
%multiplying it by the total number of samples in the track.
if track == 1
    axes = handles.mainAxes1;
    slider = handles.slider1;
    set(handles.insertSlider, 'MAX', time); %sets the values for the slider used to select where in track 1 track 2 should be added.
    set(handles.insertSlider, 'VALUE', 0);
    set(handles.insertSlider, 'MIN', 0);
elseif track == 2
    axes = handles.mainAxes2;
    slider = handles.slider2;
end

t=linspace(0,time,length(snd)); %linspace creates a vector of a number of values equal to the number of samples in the track.
%0 is placed at the start of the vector and is slowly incremented until the
%end of the vector where the final value is the length of the track in
%seconds.
plot(axes,t,snd); %plots the data onto the axes.
axesLabels(axes); %adds labels to the axes.
set(slider, 'MAX', time);
set(slider, 'VALUE', 0);
set(slider, 'MIN', 0);

function timerUpdate(~,~,track, handles)
%called by the tracks while they are playing. Updates the label on the GUI
%with the track's time.

global sampleRate;

if track == 1
    global sound1;
    global data1;
    
    slider = handles.slider1;
    text = handles.sliderText1;
    time = round(sound1.CurrentSample / sampleRate,1); %works out the time based on the current sample of the track.
    snd = data1;   
elseif track == 2
    global sound2;
    global data2;
    
    slider = handles.slider2;
    text = handles.sliderText2;
    time = round(sound2.CurrentSample / sampleRate,1); %works out the time based on the current sample of the track.
    snd = data2;
end

finalTime = get(slider, 'MAX'); %fetches the duration of the track from the track's associated slider.

if time < finalTime %if the track has not finished.
    set(slider, 'VALUE', time); %set the slider and label to the current time into the song.
    set(text, 'String', time);
else %if the track has finished
   set(slider, 'VALUE', finalTime); %set the slider and label of the current time to the final time.
   set(text, 'String', finalTime);
   updateUI(snd,sampleRate,handles,track); %update the UI to indicate the track has finished and reset everything.
end

function invert(handles, track)
%handles inverting tracks

global trackloaded1;
global trackloaded2;
global sampleRate;
global speedChanged;
stopSound(handles, track);

if track == 1 && trackloaded1   %if track 1 is passed and loaded.
    global data1;
    global sound1;
    
    data1 = flipud(data1); %flip the data matrix.
    sound1 = audioplayer(data1,sampleRate); %replace the sound1 audioplayer object with the new data.
    set(sound1,'TimerFcn',{@timerUpdate, track, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, track, handles}); %set the timer function and the rate it fires, and the stop function.
    set(handles.sliderText1, 'String', round(handles.slider1.Value, 1)); %resets the track 2 slider label.
    updateUI(data1, sampleRate, handles, 1);%update the ui with the new flipped track.
elseif track == 2 && trackloaded2 %if track 2 is passed and loaded.
    global data2;
    global sound2;
    
    data2 = flipud(data2); %flip the data matrix.
    sound2 = audioplayer(data2,sampleRate); %replace the sound1 audioplayer object with the new data.
    set(sound2,'TimerFcn',{@timerUpdate, track, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, track, handles}); %set the timer function and the rate it fires, and the stop function.
    set(handles.sliderText2, 'String', round(handles.slider2.Value, 1)); %resets the track 2 slider label.
    updateUI(data2, sampleRate, handles, 2);%update the ui with the new flipped track.
end

if(speedChanged) %if the play speed has been changed it is reset back to default.
    resetSpeed(handles);
end

function axesLabels(hObject)
%used to add the labels to the given axes.
axes = hObject;
axes.YLabel.String = 'Signal Strength';
axes.XLabel.String = 'Time(Sec)';

function changeRate(handles, sampleMultiplier)
%This function handles changes to the speed that the tracks are played at.
%the sampleMultiplier variable passed in is the number set by the user on
%the speed slider, it acts as a multiplier for the sample rate.
global data1;
global data2;
global sampleRate;
global sound1;
global sound2;
global playing1;
global playing2;
global trackloaded1;
global trackloaded2;
global speedChanged;
speedChanged = true;

resume1 = playing1; %check whether either track is playing.
resume2 = playing2;

newRate = sampleRate * sampleMultiplier; %create the new sampleRate using the old rate * the multiplier.

if(trackloaded1) %if track one is loaded.
    sound1 = audioplayer(data1, newRate); %create an audioplayer object using the new sample rate and replace the existing audioplayer object with it.
    set(sound1,'TimerFcn',{@timerUpdate,1, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, 1, handles});
    stopSound(handles,1); %run stopSound function to prepare system to play new track.
    if(resume1) %if track one was playing when this function was called play the new track.
        playSound(1);
    end
end

if(trackloaded2)%if track one is loaded.
    sound2 = audioplayer(data2, newRate); %create an audioplayer object using the new sample rate and replace the existing audioplayer object with it.
    set(sound2,'TimerFcn',{@timerUpdate,2, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, 2, handles});
    stopSound(handles,2); %run stopSound function to prepare system to play new track.
    if(resume2) %if track two was playing when this function was called play the new track.
        playSound(2);
    end
end

function resetSpeed(handles)
%Called when the reset speed button is selected. Resets the current play
%speed back to the default value.
global speedChanged;
if(speedChanged)
    changeRate(handles, 1); %calls the changeRate function to change the multiplier on the sample rate back to 1.
    set(handles.speedSlider, 'Value', 1);
end
speedChanged = false;

function combineTracks(handles)
global trackloaded1;
global trackloaded2;
global sound1;
global sound2;
global data1;
global data2;

if trackloaded1 && trackloaded2 %if both tracks are loaded
    if get(sound2, 'NumberOfChannels') == 1 
        %if track 2 is single channel the channel is duplicated.
        data2temp = [data2 data2];
    else
        data2temp = data2;
    end
    if get(sound1, 'NumberOfChannels') == 1
        %if track 1 is single channel the channel is duplicated.
        data1 = [data1 data1];
    end
    stopSound(handles,1);
    stopSound(handles,2);
    snd1=get(sound1,'TotalSamples');
    FS1=get(sound1,'SampleRate');
   
    snd2=get(sound2,'TotalSamples');
    
    insertTime=round(get(handles.insertSlider,'value')) * FS1; 
    %works out how much empty track to add before the second track based on the value of the insert slider.

    if (snd2+insertTime) > snd1 %if track 2 + insertTime have more samples than track 1
        %In this case track 1 needs extending to match.
        toBeAdded = snd2+insertTime-snd1; %work out how much empty track is required to make track 1 = track 2 and insertTime.
        silence = zeros(toBeAdded,2); %create the empty track as a matrix of zeros with two channels.
        data1 = [data1 ; silence];  %add empty track before track 1.
    end
    
    toBeAddedPre = insertTime; %hold value of insertTime in toBeAddedPre. Done to clarify the role of the variable in the next if section.
    silencePre = zeros(toBeAddedPre,2); %create the empty track to be added before track 1 as a matrix of zeros with two channels.
        
    if (snd2+insertTime) < snd1 %if track 2 + insertTime have less samples than track 1
        %In this case track 2 needs extending to match.
        toBeAddedPost = snd1 - insertTime - snd2; %work out how much empty track to add after track 2 to make it equal track 1.
        silencePost = zeros(toBeAddedPost,2); %create the empty track as a matrix of zeros with two channels.
        data2Manip = [silencePre ; data2temp ; silencePost]; %add the empty track sections before and after track 2.
    else %else if the two would be equal just add the empty track section prior to track 2.
        data2Manip = [silencePre ; data2temp];
    end
    
    data1 = data1 + data2Manip; %The two tracks are combined.
    sound1 = audioplayer(data1,FS1); %track 1 is updated with the new combined track.
    set(sound1,'TimerFcn',{@timerUpdate,1, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@songEnded, 1, handles}); %update the new track with the timer and stop functions.
    updateUI(data1,FS1,handles,1); %update the ui to reflect the track changes.
end

function saveTrack()
%function for saving tracks.
global data1;
global trackloaded1;
global sampleRate;

if trackloaded1 %if track 1 is loaded
    folderName = uigetdir('','Select a folder to save into'); %open folder explorer for users to select a folder to save into.
    if folderName
        fileName = inputdlg('Enter a file name:',... %opens a dialog box asking users to enter a file name.
                     'choose file name', [1 50]);
        if length(fileName) == 1 %Checks if a name was selected.
            path = strcat(folderName,'\',fileName,'.wav'); %formulates the filepath to save too from the selected folder and the filename.
            if exist(path{1}, 'file') == 2 %if the filename already exists create a dialog box asking if the user wants to overwrite existing file.
                confirmation = questdlg('That file already exists. Overwrite existing file?','File already exists','Yes','No','No');
                 if strcmp(confirmation,'Yes') %if the user selects yes save the file
                    audiowrite(path{1},data1,sampleRate);
                 end
            else
                audiowrite(path{1},data1,sampleRate); %save the data to the specified path.
            end
        end
    end
end
%-----------GUI callbacks and CreateFcn's---------------------------------%
%No core functionality code below. Primarily function calls and event
%listeners.
function varargout = assignmentGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function insertSlider_Callback(hObject, eventdata, handles)
%adds a listener to the value property of the insert slider to update the
%label.
addlistener(handles.insertSlider,'Value','PostSet',@(s,e) set(handles.insertTime, 'String', round(handles.insertSlider.Value, 1)));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pauseButton1.
function pauseButton1_Callback(hObject, eventdata, handles)
pauseSound(1);

% --- Executes on button press in pauseButton2.
function pauseButton2_Callback(hObject, eventdata, handles)
pauseSound(2);

% --- Executes on button press in playButton1.
function playButton1_Callback(hObject, eventdata, handles)
playSound(1);

% --- Executes on button press in playButton2.
function playButton2_Callback(hObject, eventdata, handles)
playSound(2);

% --- Executes on button press in stopButton2.
function stopButton1_Callback(hObject, eventdata, handles)
%calls the stopSound function for track 1.
stopSound(handles,1);

% --- Executes on button press in stopButton2.
function stopButton2_Callback(hObject, eventdata, handles)
%calls the stopSound function for track 2.
stopSound(handles,2);

% --- Executes on button press in selectFile1.
function selectFile1_Callback(hObject, eventdata, handles)
loadFile(handles,1);

% --- Executes on button press in selectFile2.
function selectFile2_Callback(hObject, eventdata, handles)
loadFile(handles,2);

% --- Executes on button press in combineButton.
function combineButton_Callback(hObject, eventdata, handles)
% This function handles the combining of the two tracks at the selected
% time.
combineTracks(handles);

% --- Executes during object creation, after setting all properties.
function mainAxes1_CreateFcn(hObject, eventdata, handles)
axesLabels(hObject);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in saveButton1.
function saveButton1_Callback(hObject, eventdata, handles)
%calls the saveTrack function to save the track.
saveTrack();

function insertSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function mainAxes2_CreateFcn(hObject, eventdata, handles)
%assigns labels to axes 2 on creation.
axesLabels(hObject);

% --- Executes on button press in invert1.
function invert1_Callback(hObject, eventdata, handles)
%calls the invert function for track 1.
invert(handles,1);

% --- Executes on button press in invert2.
function invert2_Callback(hObject, eventdata, handles)
%calls the invert function for track 2.
invert(handles,2);

function loop1_Callback(hObject, eventdata, handles)

% --- Executes on button press in invert2.
function loop2_Callback(hObject, eventdata, handles)

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
%calls the resetSpeed function to reset the playback speed to default.
resetSpeed(handles);

% --- Executes on slider movement.
function speedSlider_Callback(hObject, eventdata, handles)
%add an event listener to the value property of the slider to change the
%label as it changes.
addlistener(handles.speedSlider,'Value','PostSet',@(s,e) set(handles.speedLbl, 'String', round(handles.speedSlider.Value, 1)));
changeRate(handles, get(handles.speedSlider, 'Value')); %Call changeRate function to change the track's speed.

% --- Executes during object creation, after setting all properties.
function speedSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

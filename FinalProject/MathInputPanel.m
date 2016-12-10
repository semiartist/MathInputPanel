function varargout = MathInputPanel(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MathInputPanel_OpeningFcn, ...
    'gui_OutputFcn',  @MathInputPanel_OutputFcn, ...
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


% --- Executes just before MathInputPanel is made visible.
function MathInputPanel_OpeningFcn(hObject, eventdata, handles, varargin)
dbstop if error;

global drawing pointNum stroke xx yy stat timer2s endPara totalStroke numNum totalBoundry recoResult
set(gcf,'WindowButtonDownFcn',@mouseDown);
set(gcf,'WindowButtonMotionFcn',@mouseMove);
set(gcf,'WindowButtonUpFcn',@mouseUp);
set(gcf,'windowkeypressfcn' , @keyPressed);

timer2s = timer('TimerFcn', @timerEnd, 'StartFcn' , @timerStart ...
    , 'stopfcn', @timerStop,'startdelay',0.6);
% timer1s = timer('timerfcn',@refresh, 'stopfcn',@timer1sStart);
% start(timer1s);

totalStroke = [];
totalBoundry = [];
endPara = 0;
xlim([0 2]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);

numNum = 0;
drawing = 0;
pointNum = 0;
stroke = 0;

xx = 0; yy = 0;
stat = false;


clc;
% Choose default command line output for MathInputPanel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MathInputPanel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MathInputPanel_OutputFcn(hObject, eventdata, handles)


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in undoButton.
function undoButton_Callback(hObject, eventdata, handles)
global totalStroke numNum totalBoundry locResult recoResult
cla
if numNum >0;
    numNum = numNum- 1;
    totalStroke(end) = [];
%     recoResult(1,end) = [];
    totalBoundry(:,end) = [];
    locResult = final_location(totalBoundry);
    strokeNum = size(totalStroke,2);
    for s = 1:strokeNum;
        currentStroke = (totalStroke{s});
        thisNum = size(currentStroke,1);
        for jumper = 1:thisNum
            thisplot = currentStroke{jumper};
            plot(thisplot(:,1) , thisplot(:,2) , 'k' , 'linewidth' , 3);
            hold on;
        end
    end
end

% --- Executes on button press in holdButton.
function holdButton_Callback(hObject, eventdata, handles)



% --- Executes on button press in goButton.
function goButton_Callback(hObject, eventdata, handles)
% below is the old go callback function;
%{
global inkData xx yy;
disp(size(inkData));
disp(inkData);
resultStr = [];
[result caseType] = final_main(inkData);

for runner = 1:size(result,2);
    if size(result{runner},2)==1
        if result{runner} == 'x'
            xx = xx +1;
        elseif result{runner} == 'y'
            yy = yy+1;
        elseif result{runner} =='=';
            resultStr = [resultStr,' ',result{runner}];
        end
    end
    
    resultStr = [resultStr,'',result{runner}];
end
% start x or y if exist any x or y;
unknown = 0;
if xx >0;
    syms x;
    unknown = 1;
end
if yy > 0;
    syms y;
    unknown = 1;
end

switch caseType
    case 1
        if unknown ==1;
            solveResult = double(solve(resultStr))
            dispString = [];
            for runner = 1:size(solveResult,1)
                % generate String;
                dispString = [dispString, num2str(solveResult(runner)), 10];
            end
        else
            evalResult = eval(resultStr);
            if evalResult ==1;
                set(handles.resultDisplay, 'String' , 'TRUE');
                set(handles.resultDisplay, 'ForegroundColor',[1 0 0]);
            else
                set(handles.resultDisplay, 'String' , 'FALSE');
                set(handles.resultDisplay, 'ForegroundColor',[0 1 0]);
            end
        end
        
    case 0
end



set(handles.recognizeDisplay, 'String' , resultStr);
%}
global dispStr
disp(dispStr);
[dispStr , showResult, x, y ] = HMMcalculation(dispStr);
set(handles.recognizeDisplay, 'String' , dispStr);

if showResult ==0;
    resultStr = 'Wrong Result';
    set(handles.resultDisplay, 'String' , resultStr);
    set(handles.resultDisplay, 'ForegroundColor',[1 0 0]);
elseif showResult ==1;
    resultStr = 'Correct Result';
    set(handles.resultDisplay, 'String' , resultStr);
    set(handles.resultDisplay, 'ForegroundColor',[0 1 0]);
    
elseif isempty(showResult) && isempty(x) && isempty(y);
    resultStr = eval(dispStr);
    set(handles.resultDisplay, 'String' , resultStr);
    set(handles.resultDisplay, 'ForegroundColor',[0 0 0]);
    
elseif isempty(showResult) && ~isempty(x) && isempty(y);
    calStr = final_tranStr('x', (x));
    calStr = strvcat(calStr);
    set(handles.resultDisplay, 'String' , calStr);
    set(handles.resultDisplay, 'ForegroundColor',[0 0 0]);
elseif isempty(showResult) && ~isempty(y) && isempty(x);
    calStr = final_tranStr('y', (y));
    calStr = strvcat(calStr);
    set(handles.resultDisplay, 'String' , calStr);
    set(handles.resultDisplay, 'ForegroundColor',[0 0 0]);
elseif ~isempty(x) && ~isempty(y)
    calStr = final_tranStr('x', (x));
%     calStr2 = final_tranStr('y', (y));
%     calStr = [calStr1 ; calStr2];
    calStr = strvcat(calStr);
    set(handles.resultDisplay, 'String' , calStr);   
    set(handles.resultDisplay, 'ForegroundColor',[0 0 0]);
end
    % show the x or y value;

disp(x); 
disp(y);



% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
global drawing pointNum drawed stroke pointMtx inkData xx yy endPara timer2s ...
    totalBoundry totalStroke numNum locResult recoResult
endPara = 0;
stop(timer2s);
drawing = 0;
pointNum = 0;
drawed = 0;
stroke = 0;
pointMtx = zeros(1,2);
inkData = [];
xx = 0; yy = 0;
totalStroke = [];
totalBoundry = [];
numNum = 0;
locResult = [];
recoResult = [];
set(handles.recognizeDisplay,'String' , ' ');
set(handles.resultDisplay,'String' , ' ');


cla;

% --- Executes on button press in plotBtn.
function plotBtn_Callback(hObject, eventdata, handles)
global inkData totalBoundry locResult numNum recoResult totalStroke pointMtx stroke
% numNum = numNum + 1;
% totalStroke{1, end+1} = inkData;
% stroke = 0;
% pointMtx = zeros(1,2);
for runner = 1: size(inkData,1);
    plot( inkData{runner}(:,1) , inkData{runner}(:,2),'k','linewidth',3);
end
% inkData = {};
totalBoundry(:,end+1) = final_getSize(inkData);  % need to close this line;
locResult = final_location(totalBoundry);
% recoResult(1, numNum) = final_recognise(inkData);
% recoResult = ['2' , '3' , '+' , '3' , '4'];
disBtn_Callback
% % %
% dispStr = [];
% expFlag = 0;
% for runner = 1: size(locResult ,2);
%     pos = find(locResult(1,:)==runner);
%     if locResult(2,pos) == 1 && expFlag ==0;
%         expFlag = 1;
%         dispStr = [dispStr , '^('];
%     end
%     if locResult(2,pos) ==0 && expFlag == 1;
%         expFlag = 0;
%         dispStr = [dispStr , ')'];
%     end
%     if expFlag ==1 && runner == size(locResult,2)
%         dispStr = [dispStr, ')'];
%     end
%     dispStr = [dispStr, recoResult(1, runner)];
% %
% end
% set(handles.recognizeDisplay, 'String' , dispStr);

% --- Executes on button press in disBtn.
function disBtn_Callback(hObject, eventdata, handles)
global recoResult locResult dispStr
dispStr = [];
expFlag = 0;
disp(locResult);
for runner = 1: size(locResult ,2);
%     pos = find(locResult(1,:)==runner);
    if locResult(2,runner) == 1 && expFlag ==0;
        expFlag = 1;
        dispStr = [dispStr , '^'];
    end
    if locResult(2,runner) ==0 && expFlag == 1;
        expFlag = 0;
        dispStr = [dispStr , ''];
    end
    
    dispStr = [dispStr, recoResult{1, locResult(1,runner)}];
    if expFlag ==1 && runner == size(locResult,2)
        dispStr = [dispStr, ''];
    end
end
disp(dispStr);
% set(handles.recognizeDisplay, 'String' , dispStr);


% % % % % % BLOW IS THE SELF DEFINED FUNCTION FOR MOUSE ACTION % % % % % %
% % % % % % COPY RIGHT TO DR. ESFAHANI @ UNIVERSITY AT BUFFALO % % % % % %

function mouseDown(hObject, eventdata, handles)
global drawing timer2s endPara
xlim([0 2]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);
drawing = 1;
stop(timer2s)
endPara = 0;


function mouseUp(hObject, eventdata, handles)
global drawing pointNum drawed stroke pointMtx inkData timer2s
xlim([0 2]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);
drawing = 0;
pointNum = 0;


strokeL = size(pointMtx,1);

if drawed && strokeL>5;
    start(timer2s);
    stroke = stroke + 1;
    inkData{stroke,1} = pointMtx;
end
pointMtx = zeros(1,2);
drawed = 0;


function mouseMove(hObject, eventdata, handles)
global drawing pointNum drawed pointMtx
xlim([0 2]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);

currentPnt = get(gca,'CurrentPoint');
currentPnt = currentPnt(1,1:2);
if drawing && currentPnt(1,1)<2 && currentPnt(1,1)>0 &&currentPnt(1,2)<1 && currentPnt(1,2)>0;
    pointNum = pointNum+1;
    pointMtx(pointNum,1:2) = currentPnt;
    % pointMtx(pointNum,3) = toc;
    plot(currentPnt(:,1) , currentPnt(:,2) , 'b' , 'markerfacecolor','b','marker','o','markersize',1.5);
    drawed = 1;
    hold on;
end;

function keyPressed(hObject, eventdata, handles)
global timer2s endPara
if get(gcf,'currentcharacter')=='z'
    endPara = 1;
    stop(timer2s)
end


function timerStart(hObject, eventdata, handles)

function timerStop(hObject, eventdata, handles)
global endPara ;
if endPara;
    timerEnd;
end
disp('Timer is stopped!');


function timerEnd(hObject, eventdata, handles)
global  stroke pointMtx inkData totalStroke numNum recoResult

numNum = numNum + 1;
winner = final_recognise(inkData);
template=['1','2','3','4','5','6','7','8','9','0','+','-','*','/','x','y','7','.','(',')','='];
recoResult{1, numNum}=template(winner)
plotBtn_Callback;
disBtn_Callback;

totalStroke{1, end+1} = inkData;
stroke = 0;
pointMtx = zeros(1,2);
inkData = {};
% disp(totalStroke);









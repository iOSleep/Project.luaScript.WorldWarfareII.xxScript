@COLOR 20
@echo off
setlocal enabledelayedexpansion
title �ֿ�ѵ������-by����IT����
set work_path=%cd%\work
set out_path=%cd%\output
:help
cls

echo   ʹ��˵��
echo   1���Ѵ���õ�tif�ļ�����workĿ¼�� ������ʽΪ xxx.1.tif  xxx.2.tif ....
echo   2��������1������1���jTessBoxEditer �޸�box�ļ�
echo   3��������2��������ֿ�ѵ�����ϲ�����һ���ֿ�
echo   4���ֿ����Ŀ¼Ϊ%cd%\output
echo   5��Ĭ������ѵ������ ѵ��Ӣ�Ŀ������޸�tesseract %work_path%\%%a -psm 7 %work_path%\%%~na -l chi_sim batch.nochop makebox ��һ���е� -l ����psm�õ���7 ���Ҫ��6�������޸�һ��
echo   6����ȫ��Դ �뱣��title��Ȩ��ʶ
pause
goto main

:main
cls
echo ��������������������������������������������������������
echo ��                    �ֿ�ѵ������                    ��
echo ��������������������������������������������������������
echo �� 1��workĿ¼������tif�ļ�����box�ļ�                ��
echo �� 2����ʼѵ�����ϲ��ֿ�                              ��
echo �� j������jTessBoxEditer                              ��
echo �� h��ʹ��˵��                                        ��
echo �� e���˳�����                                        ��
echo ��������������������������������������������������������

set /P INPUT=������ѡ�

if "%INPUT%"=="1"  goto createbox
if "%INPUT%"=="2"  goto dotrain
if "%INPUT%"=="j"  goto startjbox
if "%INPUT%"=="h"  goto help
if "%INPUT%"=="e"  goto exit

:createbox
cls
echo ----------------------------------
echo ������ʷ�ļ�
echo ------------------------------------
del %work_path%\*.tr
del %work_path%\my.inttemp
del %work_path%\my.normproto
del %work_path%\my.pffmtable
del %work_path%\my.shapetable
del %work_path%\my.unicharset
del %work_path%\font_properties
echo ----------------------------------
echo ����workĿ¼������tif�ļ�������box
echo ------------------------------------
for /f "delims=" %%a in ('dir /aa /b %work_path%\*.tif ') do (
echo ���ڴ���%%a
if exist "%work_path%\%%~na.box" (
echo %%~na.box�Ѿ�����) else (
tesseract %work_path%\%%a -psm 7 %work_path%\%%~na -l eng batch.nochop makebox
)
echo %%~na 0 0 0 0 0 >>%work_path%\font_properties
)
echo BOX�ļ�ȫ��������� ���jTessBoxEditer�޸�BOX�ļ�
pause
goto main


:dotrain
cls
echo ----------------------------------
echo ��ʼѵ�����ϲ��ֿ�
echo -----------------------------------
echo ������Ӧ��tr�ļ�
echo -----------------------------------
for /f "delims=" %%a in ('dir /aa /b %work_path%\*.tif') do (
echo ���ڴ���%%a
tesseract %work_path%\%%a -psm 7  %work_path%\%%~na nobatch box.train
)
echo -----------------------------------
echo �������ļ�����ȡ�ַ�
echo -----------------------------------
for /f "delims=" %%a in ('dir /s /b %work_path%\*.box') do (
echo %%a>>%work_path%\boxlist.txt
)
set n=
for /f "tokens=*" %%i in (%work_path%\boxlist.txt) do set n=!n! %%i
echo %n%>%work_path%\boxlistok.txt
set /p d=<%work_path%\boxlistok.txt
unicharset_extractor %d%
del %work_path%\boxlist.txt
del %work_path%\boxlistok.txt
echo -----------------------------------
echo �������������ļ�
echo -----------------------------------
for /f "delims=" %%a in ('dir /s /b %work_path%\*.tr') do (
echo %%a>>%work_path%\trlist.txt
)
set n=
for /f "tokens=*" %%i in (%work_path%\trlist.txt) do set n=!n! %%i
echo %n%>%work_path%\trlistok.txt
set /p d=<%work_path%\trlistok.txt
mftraining -F %work_path%\font_properties -U unicharset %d%
echo -----------------------------------
echo �ۼ�����tr�ļ�
echo -----------------------------------
cntraining %d%
del %work_path%\trlist.txt
del %work_path%\trlistok.txt
echo -----------------------------------
echo �������ļ����ƶ���workĿ¼
echo -----------------------------------
ren normproto my.normproto&move my.normproto %work_path%\my.normproto
ren inttemp my.inttemp&move my.inttemp %work_path%\my.inttemp 
ren pffmtable my.pffmtable&move my.pffmtable %work_path%\my.pffmtable
ren shapetable my.shapetable&move my.shapetable %work_path%\my.shapetable
ren unicharset my.unicharset&move my.unicharset %work_path%\my.unicharset
echo -----------------------------------
echo ��ʼѵ��
echo -----------------------------------
combine_tessdata %work_path%\my.
echo -----------------------------------
echo �ƶ��ֿ��ļ�
echo -----------------------------------
move %work_path%\my.traineddata %out_path%\my.traineddata
echo ----------------------------------------------------------
echo ��� 1��3��4��5��13 �в���-1��ô��ϲ���ֿ�ѵ���ɹ�
echo �ֿ��ļ�Ŀ¼��%out_path%\my.traineddata
echo ----------------------------------------------------------

pause
goto main

:startjbox
start javaw -Xms128m -Xmx1024m -jar jTessBoxEditor/jTessBoxEditor.jar
goto main
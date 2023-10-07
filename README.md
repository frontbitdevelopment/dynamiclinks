# dynamic_link_demo

A new Flutter project.

Firebase Setup (New version)

App -> build.gradle
plugins
//add below line in plugins
id "com.google.gms.google-services"

	defaultConfig
    //add below line in defaultConfig
	multiDexEnabled true


Project-> build.gradle (use latest version)
buildscript -> dependencies->
//add below line in dependencies
classpath 'com.google.gms:google-services:4.3.13'


//dynamic link

Androidmainfest.xml -> activity tag

            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data
                    android:host="fsdynamiclink.page.link"
                    android:scheme="https" />
            </intent-filter>
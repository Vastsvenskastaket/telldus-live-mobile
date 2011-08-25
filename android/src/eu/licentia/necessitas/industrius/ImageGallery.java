package eu.licentia.necessitas.industrius;

import android.util.Log;
import android.app.Activity;
import android.content.Intent;
//import android.os.Handler;
//import android.os.Looper;
import android.os.Message;
import android.os.Bundle;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;


import android.net.Uri;
//import android.app.AlertDialog;

import eu.licentia.necessitas.industrius.QtApplication;

public class ImageGallery extends Activity{
	/*public ImageGallery(){
		super();
		//Looper.prepare();
		Log.i("Telldus", "HELLO world!");
	}*/

	public void printout(){
//		Log.i("Telldus", "Printing!");

		//runOnUiThread(new Runnable() {
		//	Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
			//i = i.addFlags(268435456);  //FLAG_ACTIVITY_NEW_TASK);

//			QtActivity currentActivity = QtApplication.mainActivity();
			//Uri uri = Uri.parse("market://search?q=pname:eu.licentia.necessitas.ministro");
			//Intent intent = new Intent(Intent.ACTION_VIEW, uri);
			//currentActivity.startActivityForResult(i, 5);

/*
//Detta:
Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
//eller detta:
Intent intent = new Intent();
intent.setType("image/*");
intent.setAction(Intent.ACTION_GET_CONTENT);
currentActivity.startActivityForResult(Intent.createChooser(intent, "Select Picture"), 5);
//...fungerar (man får välja vilket galleri man vill använda dock, kanske man inte vill), men resultatet hamnar i QtActivity...
*/


//Intent intent = new Intent(currentActivity, eu.licentia.necessitas.industrius.ImageGallery.class); //eu.licentia.necessitas.industrius.ImageGallery.class.getCanonicalName()
//currentActivity.startActivityForResult(intent, 5);



	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		Log.i("Telldus", "---------------- ON CREATE");
		super.onCreate(savedInstanceState);

		QtActivity currentActivity = QtApplication.mainActivity();
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_GET_CONTENT);
		startActivityForResult(Intent.createChooser(intent, "Pick a program to select a Layout Background from"), 5);
	}

	@Override
	 public void onActivityResult(int requestCode, int resultCode, Intent data) {
		Log.i("Telldus", "-------------- ON RESULT - right place!!!");
		super.onActivityResult(requestCode, resultCode, data);
		//If vissa saker:
		Log.i("Telldus", "Got: req: " + requestCode + ", rc: " + resultCode + ", data: " + data);

		if(requestCode == 5){

			String filePath = "";
			if(resultCode == RESULT_OK){
				Uri selectedImage = data.getData();
				Log.i("Telldus", "This: " + selectedImage);
				String[] filePathColumn = {MediaStore.Images.Media.DATA};

				Cursor cursor = QtApplication.mainActivity().getContentResolver().query(selectedImage, filePathColumn, null, null, null);
				if(cursor != null){
					if(cursor.moveToFirst()){
						int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
						filePath = cursor.getString(columnIndex);
						Log.i("Telldus", "FILE: " + filePath);
					}
					cursor.close();
				}
				else{
					//different image pickers are obviously returning different things... this seems to work when using QuickPic...
					Log.i("Telldus", "NO first in cursor!");
					Log.i("Telldus", "FILE (2): " + selectedImage);
					filePath = selectedImage.toString();
				}
			}
			pickedImage(filePath);
			finish(); //finish
		}
	}

	public static native void pickedImage(String imageurl);

	public static void pickImage(){
		Log.i("Telldus", "Printing stat!");

			QtActivity currentActivity = QtApplication.mainActivity();
			Intent intent = new Intent(currentActivity, eu.licentia.necessitas.industrius.ImageGallery.class); //eu.licentia.necessitas.industrius.ImageGallery.class.getCanonicalName()
			currentActivity.startActivity(intent); //startActivityForResult(intent, 5);

/*
		ActivityThread thr = new ActivityThread();
		thr.start();
*/
		//ImageGallery ig = new ImageGallery();
		//ig.printout();

		//return "Woot!";
	}
}
/*
class ActivityThread extends Thread{

	public Handler mHandler;

	public void run(){
		Log.i("Telldus", "Run thread");
		Looper.prepare();

		mHandler = new Handler() {
			public void handleMessage(Message msg) {
				// process incoming messages here
				Log.i("Telldus", "Meddelande");
			}
		};

		//QtActivity currentActivity = QtApplication.mainActivity();
		//Intent intent = new Intent(eu.licentia.necessitas.industrius.ImageGallery.class.getCanonicalName());
		//ImageGallery ig = new ImageGallery();
	//	ig.printout();



			QtActivity currentActivity = QtApplication.mainActivity();
			Intent intent = new Intent(currentActivity, eu.licentia.necessitas.industrius.ImageGallery.class); //eu.licentia.necessitas.industrius.ImageGallery.class.getCanonicalName()
			currentActivity.startActivity(intent); //startActivityForResult(intent, 5);

	//currentActivity.startActivityForResult(intent, 5);

		/*
		Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		i = i.addFlags(268435456);  //FLAG_ACTIVITY_NEW_TASK);
		Log.i("Telldus", i.getDataString());
		if(i != null){
			Log.i("Telldus", "Intent 1");
		}
		*/
		/*

		Looper.loop();
	}
}
*/

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const TOKEN = 'c-cPHNxtSCeUY9wgZOpMMl:APA91bHZCjvH8UQ800VTEwRPfpSXwNiN_6LzKe4r_2EMMe39i0PqW2oh5iSYAw0MZR4rMIQo6Gf2EFxV0F5dhc_g4IzjsdZ3MXiin-7eWXf4_epTFG_VRlbPRlfdElOTZfjCZl1nzf50';

exports.onTrigger = functions.database.ref('/{house}/triggered').onUpdate(async (snapshot) => {
  const status = snapshot.after.toJSON();
  console.log(status);

  if (status) {
    const payload = {
      token: TOKEN,
      notification: {
        title: 'Security Alert!',
        body: 'Your house has been invaded.',
      },
    };
    console.log(payload);

    await admin.messaging().send(payload);
  }

  return 0;
});

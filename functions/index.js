const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Cloud Function to create a new user
exports.createUser = functions.https.onCall(async (data, context) => {
  try {
    // Input validation
    if (!data.email || !data.password || !data.displayName) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing required fields');
    }

    // Create a new user in Firebase Authentication
    const user = await admin.auth().createUser({
      email: data.email,
      password: data.password,
      displayName: data.displayName,
      phoneNumber: data.phoneNumber,
    });

    // Store user data in Firestore
    await admin.firestore().collection('users').doc(user.uid).set({
      displayName: data.displayName,
      email: data.email,
      phoneNumber: data.phoneNumber,
      licenseNumber: data.licenseNumber,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      status: 1, // 1 for enabled, 0 for disabled
      role: 'driver', // Assign role
    });

    // Return success with the user's UID
    return { success: true, uid: user.uid };
  } catch (error) {
    console.error('Error creating user:', error);
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    throw new functions.https.HttpsError('internal', 'An unexpected error occurred');
  }
});

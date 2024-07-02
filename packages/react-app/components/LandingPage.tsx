// src/components/LandingPage.tsx
import React from 'react';

const LandingPage: React.FC = () => {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-8">
      <h1 className="text-6xl font-bold text-yellow-600 mb-4">RewardFlow</h1>
      <h2 className="text-3xl text-green-600 mb-8">Automated Reward Distribution System</h2>
      <div className="max-w-3xl mx-auto text-left">
        <h4 className="text-2xl font-semibold text-yellow-600 mb-4">What is RewardFlow?</h4>
        <p className="text-lg text-gray-700 mb-8">
          RewardFlow is a decentralized platform that allows businesses to set up and manage reward programs
          based on customer spending and engagement.
        </p>
        <div className="text-center my-8">
          <a href="/dashboard" className="px-6 py-3 bg-green-600 text-white text-lg font-semibold rounded hover:bg-green-700">
            Enter App
          </a>
        </div>
        <h4 className="text-2xl font-semibold text-yellow-600 mb-4">Features</h4>
        <ul className="list-disc list-inside text-lg text-gray-700 mb-8">
          <li>Businesses can easily set up reward programs.</li>
          <li>Automated tracking of user activity and spending using smart contracts.</li>
          <li>Weekly or monthly reward distribution based on predefined criteria.</li>
          <li>Integration with SubQuery for tracking on-chain activity.</li>
        </ul>
        <h4 className="text-2xl font-semibold text-yellow-600 mb-4">Get Started</h4>
        <p className="text-lg text-gray-700 mb-8">
          Join RewardFlow today and start rewarding your loyal customers with ease.
        </p>
      </div>
    </div>
  );
};

export default LandingPage;

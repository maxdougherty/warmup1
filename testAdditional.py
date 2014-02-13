import unittest
import os
import testLib

class TestSystem(testLib.RestTestCase):
	
	def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
		expected = { 'errCode' : errCode }
		if count is not None:
			expected['count'] = count
		self.assertDictEqual(expected, respData)

	def testSignIn(self):
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, count = 2)

	def testReset(self):
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = -1, count = None)

	def testMultiAddAndLogin(self):
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user2', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user3', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, count = 2)
		respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user2', 'password' : 'password'})
		self.assertResponse(respData, count = 2)
		respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user3', 'password' : 'password'})
		self.assertResponse(respData, count = 2)

	def testUsernameErrors(self):
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : '', 'password' : 'password'})
		self.assertResponse(respData, errCode = -3, count = None)
		val = ""
		for index in range(0, 130):
			val = val + "x"
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : val, 'password' : 'password'})
		self.assertResponse(respData, errCode = -3, count = None)

		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user2', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user2', 'password' : 'password'})
		self.assertResponse(respData, errCode = -2, count = None)

	def testPasswordErrors(self):
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		val = ""
		for index in range(0, 130):
			val = val + "x"
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user3', 'password' : val})
		self.assertResponse(respData, errCode = -4, count = None)

	def testBadLogin(self):
		respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = { 'user' : 'user1', 'password' : 'password'})
		self.assertResponse(respData, errCode = 1, count = None)
		respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user2', 'password' : 'password'})
		self.assertResponse(respData, count = 1)
		respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user2', 'password' : 'badpass'})
		self.assertResponse(respData, errCode = -1, count = None)


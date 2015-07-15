<?php

/**
 *
 * DB-IP.com API client class
 *
 * Copyright (C) 2012 db-ip.com
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

class DBIP_Client_Exception extends Exception {

}

class DBIP_Client {

	private $base_url = "http://api.db-ip.com/";
	private $api_key;

	public function __construct($api_key, $base_url = null) {
		
		$this->api_key = $api_key;

		if (isset($base_url)) {
			$this->base_url = $base_url;
		}

	}

	protected function Do_API_Call($method, $params = array()) {

		$qp = array("api_key=" . $this->api_key);
		foreach ($params as $k => $v) {
			$qp[] = $k . "=" . urlencode($v);
		}
		
		$url = $this->base_url . $method . "?" . implode("&", $qp);

		if (!$jdata = @file_get_contents($url)) {
			throw new DBIP_Client_Exception("{$method}: unable to fetch URL: {$url}");
		}

		if (!$data = @json_decode($jdata)) {
			throw new DBIP_Client_Exception("{$method}: error decoding server response");
		}

		if (property_exists($data, 'error') && $data->error) {
			throw new DBIP_Client_Exception("{$method}: server reported an error: {$data->error}");
		}

		return $data;
	
	}
	
	public function Get_Address_Info($addr) {
		
		return $this->Do_API_Call("addrinfo", array("addr" => $addr));
		
	}

	public function Get_Key_Info() {

		return $this->Do_API_Call("keyinfo");
	
	}

}

?>

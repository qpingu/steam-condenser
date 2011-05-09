<?php
/**
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2010-2011, Sebastian Staudt
 *
 * @author     Sebastian Staudt
 * @license    http://www.opensource.org/licenses/bsd-license.php New BSD License
 * @package    Steam Condenser (PHP)
 * @subpackage Steam Community
 */

require_once STEAM_CONDENSER_PATH . 'steam/community/tf2/TF2Item.php';
require_once STEAM_CONDENSER_PATH . 'steam/community/GameInventory.php';

/**
 * Represents the inventory (aka. Backpack) of a Team Fortress 2 player
 *
 * @package    Steam Condenser (PHP)
 * @subpackage Steam Community
 */
class TF2Inventory extends GameInventory {

    const APP_ID = 440;

    const ITEM_CLASS = 'TF2Item';

    /**
     * @var TF2Inventory[]
     */
    protected static $cache = array();

    /**
     * Clears the inventory cache
     */
    public static function clearCache() {
        self::$cache = array();
    }

        /**
     * This checks the cache for an existing inventory. If it exists it is
     * returned. Otherwise a new inventory is created.
     *
     * @param string $steamId64 The 64bit Steam ID of the user
     * @param bool $fetchNow Whether the data should be fetched now
     * @param bool $bypassCache Whether the cache should be bypassed
     */
    public static function create($steamId64, $fetchNow = true, $bypassCache = false) {
        if(self::isCached($steamId64) && !$bypassCache) {
            $inventory = self::$cache[$steamId64];
            if($fetchNow && !$inventory->isFetched()) {
                $inventory->fetch();
            }
            return $inventory;
        } else {
            return new TF2Inventory($steamId64, $fetchNow);
        }
    }

    /**
     * Returns whether the requested inventory is already cached
     *
     * @param string $steamId64 The 64bit Steam ID of the user
     * @return bool Whether the inventory of the given user is already cached
     */
    public static function isCached($steamId64) {
        return array_key_exists($steamId64, self::$cache);
    }

}
?>

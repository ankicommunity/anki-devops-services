# Based on the work of tsudoko and their contributors
# https://github.com/tsudoko/anki-sync-server

from .Utils import url_ending_with_slash
import anki.sync
import anki.hooks
import aqt


class SyncRedirector:
    def __init__(self, configured_sync_url, configured_msync_url):
        """
        Expects urls ending with /sync and /msync or /sync/ and /msync/.
        """
        self.configured_sync_url = configured_sync_url
        self.configured_msync_url = configured_msync_url

    def print_introduction():
        print("== SyncRedirector Addon ==")

    def print_config(self):
        print("/sync URL: " + self.configured_sync_url)
        print("/msync URL: " + self.configured_msync_url)

    def print_restart_warning():
        print(
            "WARNING: please restart Anki after configuring this addon in order to the changes take effect!"
        )

    def reconfigure_anki_syncing(self):
        """
        Expects urls ending with /sync and /msync or /sync/ and /msync/.
        """
        print("Configuring Anki to sync against custom servers...")

        anki.hooks.addHook("profileLoaded", resetHostNum)
        anki.sync.SYNC_BASE = self._parse_sync_url_for_anki_desktop()
        anki.sync.SYNC_MEDIA_BASE = self._parse_msync_url_for_anki_desktop()

    def _parse_sync_url_for_anki_desktop(self):
        """
        Expects url ending with /sync or /sync/
        """
        return url_ending_with_slash(self.configured_sync_url.strip("/sync")) + "%s"

    def _parse_msync_url_for_anki_desktop(self):
        """
        Expects url ending with /msync or /msync/
        """
        return url_ending_with_slash(self.configured_msync_url) + "%s"


def resetHostNum():
    aqt.mw.pm.profile["hostNum"] = None

package com.muhsinalper.zehir;

import net.kyori.adventure.text.Component;
import org.bukkit.Material;
import org.bukkit.NamespacedKey;
import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.bukkit.inventory.ItemStack;
import org.bukkit.inventory.meta.BookMeta;
import org.bukkit.persistence.PersistentDataContainer;
import org.bukkit.persistence.PersistentDataType;
import org.bukkit.plugin.java.JavaPlugin;

import java.nio.charset.StandardCharsets;

public final class ZehirMcNBT extends JavaPlugin implements CommandExecutor {
    private static final int DEFAULT_BYTES = 64 * 1024;
    private static final int MAX_BYTES = 20 * 1024 * 1024;
    private static final int CHUNK_BYTES = 30000;

    private NamespacedKey sizeKey;
    private NamespacedKey chunksKey;

    @Override
    public void onEnable() {
        sizeKey = new NamespacedKey(this, "payload_bytes");
        chunksKey = new NamespacedKey(this, "payload_chunks");

        if (getCommand("zehir") != null) {
            getCommand("zehir").setExecutor(this);
        }
        getLogger().info("ZehirMcNBT aktif. Kontrollu test limiti: 20 MB.");
    }

    @Override
    public boolean onCommand(CommandSender sender, Command command, String label, String[] args) {
        if (!(sender instanceof Player player)) {
            sender.sendMessage("Bu komut oyuncu tarafindan kullanilmali.");
            return true;
        }

        if (!player.hasPermission("zehir.test")) {
            player.sendMessage(Component.text("Bu komut icin yetkin yok."));
            return true;
        }

        int size = DEFAULT_BYTES;

        if (args.length > 0) {
            try {
                size = parseSize(args[0]);
            } catch (IllegalArgumentException ex) {
                player.sendMessage(Component.text(
                    "Kullanim: /zehir [64kb|256kb|1mb|5mb|10mb|15mb|20mb]"
                ));
                return true;
            }
        }

        player.sendMessage(Component.text(
            "Kontrollu test kitabi hazirlaniyor: " + formatBytes(size) + "."
        ));

        ItemStack book = createBook(size);
        player.getInventory().addItem(book);
        player.sendMessage(Component.text(
            "Unicode/PDC test kitabi verildi: " + formatBytes(size) + "."
        ));
        return true;
    }

    private int parseSize(String value) {
        String s = value.toLowerCase();

        return switch (s) {
            case "64kb" -> 64 * 1024;
            case "256kb" -> 256 * 1024;
            case "1mb" -> 1 * 1024 * 1024;
            case "5mb" -> 5 * 1024 * 1024;
            case "10mb" -> 10 * 1024 * 1024;
            case "15mb" -> 15 * 1024 * 1024;
            case "20mb" -> 20 * 1024 * 1024;
            default -> throw new IllegalArgumentException("Unsupported size");
        };
    }

    private ItemStack createBook(int targetBytes) {
        ItemStack item = new ItemStack(Material.WRITTEN_BOOK);
        BookMeta meta = (BookMeta) item.getItemMeta();

        meta.title(Component.text("Unicode NBT Test"));
        meta.author(Component.text("TurboMinecraft"));
        meta.addPages(Component.text("Unicode/PDC kontrollu test kitabi."));

        PersistentDataContainer pdc = meta.getPersistentDataContainer();
        byte[] payload = createPayload(targetBytes);
        int chunks = (payload.length + CHUNK_BYTES - 1) / CHUNK_BYTES;

        for (int i = 0; i < chunks; i++) {
            int start = i * CHUNK_BYTES;
            int end = Math.min(start + CHUNK_BYTES, payload.length);

            String chunk = new String(
                payload, start, end - start, StandardCharsets.UTF_8
            );

            pdc.set(
                new NamespacedKey(this, "unicode_payload_" + i),
                PersistentDataType.STRING,
                chunk
            );
        }

        pdc.set(sizeKey, PersistentDataType.INTEGER, payload.length);
        pdc.set(chunksKey, PersistentDataType.INTEGER, chunks);

        item.setItemMeta(meta);
        return item;
    }

    private byte[] createPayload(int targetBytes) {
        String arabic = "ض";
        String emoji = "💥";
        StringBuilder text = new StringBuilder(targetBytes / 3);
        int bytes = 0;

        while (bytes + 2 <= targetBytes) {
            text.append(arabic);
            bytes += 2;

            if (bytes + 4 <= targetBytes) {
                text.append(emoji);
                bytes += 4;
            }
        }

        byte[] result = text.toString().getBytes(StandardCharsets.UTF_8);

        while (result.length > targetBytes) {
            text.deleteCharAt(text.length() - 1);
            result = text.toString().getBytes(StandardCharsets.UTF_8);
        }

        return result;
    }

    private String formatBytes(int bytes) {
        if (bytes >= 1024 * 1024) {
            return (bytes / (1024 * 1024)) + " MB";
        }
        return (bytes / 1024) + " KB";
    }
}
